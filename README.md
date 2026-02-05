# PMO Construction Project Database

## Description
This project is a Project Management Office (PMO) database system designed for construction projects. It uses a hybrid database approach by combining a relational database and a NoSQL database to manage both structured and unstructured data efficiently. The system is implemented using SQL Server, MongoDB, and a Python-based Fast API.

The project aims to support construction project operations, reporting, document management, and auditing through a scalable and flexible architecture.

## Technologies Used
- SQL Server (Relational Database)
- MongoDB (NoSQL Database)
- Python (Fast API Development)
- Visual Studio Code (IDE)

## System Architecture

### SQL Server (Structured Data)
The relational database stores core business and transactional data, including:
- Clients
- Departments
- Disciplines
- Roles
- Employees
- Projects
- Project Phases
- Tasks
- Project Teams
- Budgets
- Milestones
- Contractors
- Project Contractors
- Suppliers
- Materials
- Equipment
- Maintenance Schedules
- Safety Compliance Records
- Site Employees

### MongoDB (Unstructured and Semi-Structured Data)
The NoSQL database stores flexible, document-based data, including:
- Progress Reports
- Risk Records
- Document Management


### API Layer
- Developed using Python
- Provides RESTful endpoints
- Handles CRUD operations for both SQL Server and MongoDB

## Features
- Construction project and PMO data management
- Hybrid SQL and NoSQL database design
- REST API for data access
- Scalable and modular system architecture
- Support for reporting, risk tracking, and auditing

## Installation and Setup

### Prerequisites
- Python 3.x
- SQL Server
- MongoDB
- Git

### Steps

1. **Clone the repository:**  
 
    `git clone https://github.com/AliKozmo/construction_PMO.git `
    `cd construction_PMO `


2. **Install Python dependencies:**
    `pip install -r requirements.txt `
   
3. **Set up the database:**

    Make sure **Docker** is running.
    From the `mongo-local` folder (where `compose.yaml` is located), run:
    `docker compose up -d `

4. **Configure database connections:**
    Make sure SQL Server is installed and running locally. Connect using:
        Server name: localhost
        Authentication type: Windows Authentication
    Make sure MongoDB is installed and running locally.
        The default connection (mongodb://localhost:27017/) will be used.
    No changes to the code or environment variables are required if you are using these default settings.

5. **Run the API with Uvicorn (development mode):**

    From the project_api folder (where `main.py` is located), run:
    `uvicorn main:app --reload`

    The API will be accessible at: `http://127.0.0.1:8000/docs`

6. **Stop Docker containers when done:**
    `docker compose down`

- Using `uvicorn main:app --reload` automatically reloads the server when you make changes
- Docker ensures MongoDB runs locally without manual installation.  

## Future Enhancements
- Implement authentication and role-based access control
- Add frontend dashboard
- Enhance reporting and analytics features
- Containerize the application using Docker

## Author
GitHub: `https://github.com/AliKozmo`