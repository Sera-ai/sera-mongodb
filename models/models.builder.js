const mongoose = require("mongoose");
const { seraConnection } = require("./db.handler");

const dataSchema = new mongoose.Schema(
  {
    nodes: {
      type: mongoose.Schema.Types.Mixed,
      validate: {
        validator: function (value) {
          // Validate that it's either an array of objects or a nested object
          return (
            Array.isArray(value) ||
            (typeof value === "object" && value !== null && !Array.isArray(value))
          );
        },
        message: "Nodes must be either an array of objects or a nested object."
      },
      required: true
    },
    edges: {
      type: mongoose.Schema.Types.Mixed,
      validate: {
        validator: function (value) {
          // Validate that it's either an array of objects or a nested object
          return (
            Array.isArray(value) ||
            (typeof value === "object" && value !== null && !Array.isArray(value))
          );
        },
        message: "Edges must be either an array of objects or a nested object."
      },
      required: true
    },
    enabled: {
      type: Boolean,
      required: false
    }
  },
  { collection: "builder_inventory", strict: false }
);

module.exports = seraConnection.model("builder_inventory", dataSchema);
