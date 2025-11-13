# S-DCRMS-Self-driving-car-rental-management-system-  
link Figma:https://www.figma.com/design/UgccNWtNcCD3wRWusW898q/Untitled?node-id=0-1&t=MlCDcXV30Ii1A5wJ-1

https://app.diagrams.net/#G1BhdIVSWBMGQ57wZNI3nHC3cF-_3Z33-o#%7B%22pageId%22%3A%22h4wHcX7NKcpAACmK_krO%22%7D  
The S-DCRMS project helps people rent cars easily

English: Self-driving car rental management system.  
Vietnamese: Hệ thống quản lý cho thuê xe tự lái.  
Abbreviation: CRA  
Context:  
In recent years, the demand for self-drive car rentals has grown rapidly. Many individuals prefer renting a car for personal use, travel, or business without relying on a driver. This trend is driven by factors such as flexibility, cost-effectiveness, and the desire for privacy and independence.  
The proposed application aims to provide a seamless platform for users to search, compare, and book self-drive cars online. It also enables car owners to list and manage their vehicles efficiently. The system will support both mobile and web platforms, ensuring accessibility anytime, anywhere.  
Proposed Solutions  
Develop a web and mobile platform for car owners, customers, staff, and admins. Enhance the system to improve user experience, fraud prevention, and operational efficiency:  
Car Owner: Manage cars, bookings, customers, payments.  
Customer: Search, book, review, pay for self-driving cars.  
Staff: Support users, manage feedback, reports.  
Admin: Oversee policies, compliance, revenue, fraud detection.  
Functional requirement  
The main processing flows are as follows:  
Car Owners:  
Register and list self-drive cars for rent  
Manage car availability, pricing, and booking calendar  
Receive and respond to customer inquiries  
Track car usage and maintenance schedules  
Manage payments and rental history  
Receive automated notifications for bookings and returns.  
Customers:  
Search cars by location, type, price, and availability  
View detailed car profiles with images, specs, and rental terms  
Book cars directly through mobile or web app  
Check-in/check-out digitally via app or kiosk  
Rate and review rental experience  
Receive real-time notifications and booking confirmations  
Access rental history and invoices  
Staff:  
Manage car owner and customer accounts  
Monitor booking activities and feedback  
Send system-wide notifications  
Reports and statistics  
Admin:  
Oversee system operations and user roles  
Monitor financial transactions and compliance  
Reports and statistics  
Non-functional requirement  
Real-time ordering  
Third party payment  
Notifications  

3.2. Main proposal content (including results and products)  
Theory and Practice:  
Students should apply the software development process and UML 2.0 in the modeling system.  
The documents include User Requirement, Software Requirement Specification, Architecture Design, Detail Design, System Implementation, and Testing Document, Installation Guide, sources code, and deployable software packages.  
Technology Server-side technologies:  
Server: .NET, Windows Azure, …  
Database Design: SQL Server, Postgre Sql, ....  
Client-side technologies:  
Web Client: HTML5, CSS3, Javascript, ReactJS, ...  
Mobile App: Flutter, React Native ...  
Communication: Web services, API integration, cloud-based notifications.  
AI Integration (optional): Chatbot for booking assistance, …  
Products:  
Mobile application for Car Owner: Register vehicles, manage bookings, customers, and payments.  
Mobile application for Customer: Search, book, pay, manage rentals, leave feedback.  
Web application for Staff: Customer & car owner management, handle reports, send notifications.  
Web application for Admin: Staff management, compliance policies, fraud detection, revenue dashboards.  
Proposed Tasks:  
Task 1: Develop web app for Admin, Staff, and Car Owners  
Task 2: Develop mobile app for Customers (with booking and check-in features)  
Task 3: Integrate AI features (chatbot, dynamic pricing, smart reports)  
Task 4: Test and deploy the system  
Task 5: Prepare documentation (SRS, SAD, Test Plan, User Manual)  

```
S-DCRMS/
│
├── Server/
│   ├── ApiGateway/              # Ocelot hoặc YARP (1 người)
│   ├── AuthService/             # Identity + JWT (1 người)
│   ├── OwnerCarService/         # Chủ xe, xe, bảo trì (1 người)
│   ├── BookingPaymentService/   # Đặt xe, thanh toán (1 người)
│   └── NotificationService/     # Email/SMS queue (1 người)
├── Client/
│   └── src/
│       ├── api/                 # Chứa các file gọi API (axios, fetch, v.v.)
│       ├── assets/              # Ảnh, icon, fonts, CSS tĩnh
│       ├── components/          # Component tái sử dụng (Button, Navbar, Card,...)
│       ├── hooks/               # Custom hooks (useAuth, useFetch,...)
│       ├── layouts/
│       ├── pages/               # Mỗi màn hình chính trong app
│       ├── styles/
│       └── utils/
├── docker-compose.yml           # Kết nối toàn hệ thống
└── SDCRMS.sln                   # Solution chính
```
