const mongoose = require("mongoose");
const { seraConnection } = require("./db.handler");

const dataSchema = new mongoose.Schema(
  {
    user: {
      required: true,
      type: String,
    },
    firstName: {
      required: true,
      type: String,
    },
    lastName: {
      required: false,
      type: String,
    },
    toastables: {
      required: false,
      type: Array,
    },
  },
  { collection: "sera_settings", strict: false }
);

module.exports = seraConnection.model("sera_settings", dataSchema);
