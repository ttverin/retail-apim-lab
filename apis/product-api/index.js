const { app } = require("@azure/functions");
const { ServiceBusClient } = require("@azure/service-bus");

function normalizeMessage(message) {
    if (typeof message === "string") {
        try {
            return JSON.parse(message);
        } catch {
            return { rawBody: message };
        }
    }

    if (message && typeof message === "object" && typeof message.body === "string") {
        try {
            return JSON.parse(message.body);
        } catch {
            return message;
        }
    }

    if (message && typeof message === "object" && message.body && typeof message.body === "object") {
        return message.body;
    }

    return message;
}

// GET /api/productApi - list products
app.http("productApi", {
    methods: ["GET"],
    authLevel: "anonymous",
    handler: async (request, context) => {
        context.log("Product API triggered");
        return {
            status: 200,
            jsonBody: {
                message: "Products retrieved successfully",
                data: [
                    { id: 1, name: "Laptop", price: 1200 },
                    { id: 2, name: "Phone", price: 800 }
                ]
            }
        };
    }
});

// POST /api/orders - accept order and enqueue (returns 202 immediately)
app.http("enqueueOrder", {
    methods: ["POST"],
    authLevel: "anonymous",
    route: "orders",
    handler: async (request, context) => {
        const body = await request.json().catch(() => ({}));
        const orderId = `order-${Date.now()}`;

        const client = new ServiceBusClient(process.env.SERVICEBUS_CONNECTION);
        const sender = client.createSender(process.env.SERVICEBUS_QUEUE_NAME);
        try {
            await sender.sendMessages({
                body: { orderId, ...body, timestamp: new Date().toISOString() },
                contentType: "application/json",
                subject: "new-order"
            });
            context.log("Order enqueued", orderId);
            return {
                status: 202,
                jsonBody: { message: "Order accepted and queued for processing", orderId }
            };
        } finally {
            await sender.close();
            await client.close();
        }
    }
});

// Service Bus queue trigger - processes orders
app.serviceBusQueue("productQueueProcessor", {
    connection: "SERVICEBUS_CONNECTION",
    queueName: "%SERVICEBUS_QUEUE_NAME%",
    handler: async (message, context) => {
        const payload = normalizeMessage(message);

        if (payload?.forceFail) {
            context.log("Demo poison message received, forcing retry/dead-letter flow", payload);
            throw new Error("Forced failure for dead-letter demo");
        }
        context.log("Processing order from queue", payload);
    }
});

// Dead-letter queue monitor - fires when a message fails max_delivery_count times
app.serviceBusQueue("deadLetterMonitor", {
    connection: "SERVICEBUS_CONNECTION",
    queueName: "%SERVICEBUS_DLQ_NAME%",
    handler: async (message, context) => {
        const payload = normalizeMessage(message);
        context.log("⚠️ Dead-lettered message detected", {
            message: payload,
            deadLetterReason: context.triggerMetadata?.deadLetterReason,
            deadLetterErrorDescription: context.triggerMetadata?.deadLetterErrorDescription
        });
    }
});
