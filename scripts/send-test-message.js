/**
 * Quick test script: sends one message to the Service Bus queue
 * Usage:
 *   SERVICEBUS_CONNECTION="<connection-string>" node scripts/send-test-message.js
 */

const { ServiceBusClient } = require("@azure/service-bus");

const connectionString = process.env.SERVICEBUS_CONNECTION;
const queueName = process.env.SERVICEBUS_QUEUE_NAME || "product-queue";

if (!connectionString) {
  console.error("ERROR: Set SERVICEBUS_CONNECTION env var before running.");
  process.exit(1);
}

async function main() {
  const client = new ServiceBusClient(connectionString);
  const sender = client.createSender(queueName);

  const message = {
    body: {
      orderId: `test-${Date.now()}`,
      productId: 1,
      quantity: 2,
      timestamp: new Date().toISOString(),
    },
    contentType: "application/json",
    subject: "test-order",
  };

  try {
    await sender.sendMessages(message);
    console.log(`✅ Message sent to queue "${queueName}":`, JSON.stringify(message.body, null, 2));
  } finally {
    await sender.close();
    await client.close();
  }
}

main().catch((err) => {
  console.error("❌ Failed to send message:", err.message);
  process.exit(1);
});

