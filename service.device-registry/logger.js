/**
 * A simple, colorful JS logger
 * @author Cedric Grothues
 *
 * @param {string} name - The name of the service that triggered the logger
 *
 * All logger functions have one parameters:
 * @param {any} message - A custom message to log
 */

/**
 * Produces a `console.log` with the service name colored with `\x1b[36m` (turquise) and in square brackets
 *
 *    logger.info("Server is up and running on port 4000")
 *
 * Output: `[service.device-registry] Server is up and running on port: 4000`
 */
const info = (name, message) => {
  console.log("\n\x1b[36m%s\x1b[0m%s", `[${name}] `, message);
};

/**
 * Produces a `console.warn` with the service name colored with `\x1b[33m` (yellow) and in square brackets.
 * This is supposed to be used to warn the user of an error that is likely to happen if no action is taken.
 *
 *    logger.warn("This function is deprecated and will be removed in a future update!")
 */
const warn = (name, message) => {
  console.warn("\x1b[33m%s\x1b[0m%s", `[${name}] `, message);
};

/**
 * Produces a `console.error` with the service name colored with `\x1b[31m` (red) and in square brackets
 *
 *    logger.error("Error while parsing JSON from " + url + "! Error: " + err)
 */
const error = (name, message) => {
  console.error("\x1b[31m%s\x1b[0m%s", `[${name}] `, message);
};

module.exports = { info, warn, error };
