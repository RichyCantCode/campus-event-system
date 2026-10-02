using System;
using Microsoft.Data.SqlClient;

namespace EventSystem.Backend
{
    public class RegistrationService
    {
        private readonly string _connectionString = "Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;";

        /// <summary>
        /// Securely fetches registration details by user email using parameterized queries and proper resource disposal.
        /// </summary>
        public string GetUserRegistration(string inputEmail)
        {
            if (string.IsNullOrWhiteSpace(inputEmail))
            {
                throw new ArgumentException("Email input cannot be null or empty.", nameof(inputEmail));
            }

            const string query = "SELECT status FROM Registrations r " +
                                 "INNER JOIN Users u ON r.user_id = u.user_id " +
                                 "WHERE u.email = @Email";

            // Enforce proper disposal using 'using' statements for SqlConnection and SqlCommand
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Parameterized query prevents SQL Injection vulnerabilities
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar, 150).Value = inputEmail;

                    conn.Open();
                    object result = cmd.ExecuteScalar();

                    return result != null ? result.ToString() : "No Registration Found";
                }
            }
        }
    }
}