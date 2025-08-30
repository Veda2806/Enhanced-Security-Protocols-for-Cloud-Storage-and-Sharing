# Enhanced Security Protocols for Cloud Storage and Sharing

A **Java EE Web Application** for secure cloud-based file storage and sharing.  
Implements **AES encryption**, **Role-Based Access Control (RBAC)**, **Attribute-Based Access Control (ABAC) simulation**, and **EDoS protection** to ensure files are accessed only by authorized users with valid roles/attributes.

---


## 🚀 Features
- **AES-256 Encryption** – All files are encrypted before storing in the cloud.
- **Dual Access Control** – RBAC + ABAC simulation for fine-grained security.
- **Secure Key Storage** – AES keys stored securely on the cloud server.
- **Download Protection** – Suspicious activity alerts & rate limiting (EDoS defense).
- **Responsive UI** – JSP + Bootstrap for a modern look.
- **Cloud Ready** – Deployable on AWS EC2, Render, Railway, or other cloud platforms.

---

## 🛠️ Tech Stack
- **Backend:** Java EE (JSP, Servlets)
- **Frontend:** HTML, CSS, Bootstrap, JavaScript
- **Database:** MySQL
- **Security:** AES-256 Encryption, RBAC, ABAC Simulation
- **Server:** Apache Tomcat
- **Cloud:** AWS EC2 / RDS (or compatible hosting)
- **Version Control:** Git + GitHub

---

## 📂 Project Structure

/src # Java source code
/webapp or WebContent # JSP pages, CSS, JS, images
/WEB-INF # web.xml configuration
/database # SQL scripts (schema.sql)
/release # WAR file for deployment


---

## ⚙️ Installation & Setup

### 1️⃣ Clone Repository
```bash
git clone https://github.com/Veda2806/Enhanced-Security-Protocols-for-Cloud-Storage-and-Sharing.git
cd Enhanced-Security-Protocols-for-Cloud-Storage-and-Sharing
2️⃣ Database Setup
1.Install MySQL (or use AWS RDS).
2.Create database
3.Import schema
4.Update DBConnection.java with your MySQL credentials.
3️⃣ Deploy WAR File
Copy release/project.war to Tomcat’s /webapps/ directory.
1.Start Tomcat
2.Access the app


