const { app } = require("@azure/functions");

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
