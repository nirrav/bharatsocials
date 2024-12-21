const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
// 
// Cloud Function triggered when a new user is created
/**
 * Sets custom claims for the user based on their email.
 * @param {firebase.auth.UserRecord} user - The user record.
 * @return {Promise} A promise that resolves when custom claims are set.
 */
exports.setUserRole = functions.auth.user().onCreate((user) => {
    // Determine the user's role
    const userRole = getUserRole(user); // This function defines the user's role

    // Set the custom claims (role) for the user
    return admin.auth().setCustomUserClaims(user.uid, { role: userRole });
});

// Custom function to define role based on email, domain, etc.
/**
 * Determines the role of the user based on their email.
 * @param {firebase.auth.UserRecord} user - The user record.
 * @return {string} The role of the user (e.g., 'volunteer', 'ngo', 'admin').
 */
function getUserRole(user) {
    // Example role assignment based on email (this can be expanded)
    if (user.email.includes("volunteer")) {
        return "volunteer";
    } else if (user.email.includes("ngo")) {
        return "ngo";
    } else if (user.email.includes("admin")) {
        return "admin";
    } else {
        return "guest"; // Default role if none of the above match
    }
}
