<p style="text-align: center;"><b>Habitual is a project focused in the field of productivity, allowing users add habits they want to improve and show them real-time progress and basic statistics for each habit as they progress.</b></p>

<h3>Design Documentation Below</h3>
<h4>Design Introduction</h4>
This design document includes an overall solution of how I plan to develop the app. This includes UI mockups, and the process flow of the app shown in the flowchart below. It is designed using MVC architecture because I believe it makes the most sense for the complexity of the app. Choosing this architecture leaves less room for error because of fewer moving parts and because this is my first experience building a fully functional app in Swift, room for error should be kept to a minimum.

<h4>Tech Stack</h4>
The app was developed in XCode and coded in Swift. The database is hosted in AWS as an RDS service with MySQL used as the database schema. The API was written in Node.JS Express and Postman was used to test it.

<h4>Tech learned during project</h4>
Through planning and development, I used industry tools like XCode, Jira and Postman. I haven't coded in Swift up to the point of starting this project so it was good experience getting hands-on with iOS development and learning a new language.

<h4>Logical Solution Design:</h4>
<img src="https://github.com/user-attachments/assets/90f38fd4-7076-4654-a094-b1ade5e0c17e" width=70% height=70%>

<h4>Physical Solution Design:</h4>

![Physical Diagram - No Name Tag](https://github.com/user-attachments/assets/b2753337-39ff-402c-aeb6-125133e036b5)

<h3>Key Technical Design Decisions:</h3>
My core technical design decisions are utilizing Swift and the Swift UI, and Swift Charts frameworks. Additionally, I will use AWS to host my data through RDS to ensure reliable uptime and use GitHub for version control. I also plan on hosting the Express API if putting Habitual on the App Store becomes in-scope. Also, since the Express API will handle all communication with the database, it will act as a Data Access Object (DAO) for the business classes to directly communicate with, as shown in the logical diagram.

<h4>Database ER Diagram:</h4>

<img src="https://github.com/user-attachments/assets/b0c1b666-d850-4d36-b6b7-6fd0644997fb" width=40% height=40%>

Each Habit object will entail details including a user_id which is used to link habits to a specific user. Each Record object will likewise be linked to a habit through a habit_id to ensure that users only see their own list of habits and expected records.

<h4>Flowchart Diagram:</h4>

<img src="https://github.com/user-attachments/assets/8cc8ca44-e65f-4e6d-983b-4a19df7c32c4" width=75% height=75%>

The logical flow of the app as the user would see it. Green nodes indicate where the user will start.

<h4>Sitemap Diagram:</h4>

<img src="https://github.com/user-attachments/assets/8d82afa1-1148-4e47-b8a7-a9ea0b72f21b" width=75% height=75%>

The sitemap shows the technical flow of the app at a high level.

<h3>UI Wireframes:</h3>
<img src="https://github.com/luke0545/Habitual-iOS/assets/56170386/6d56de55-04f1-4987-b2ef-f4e15c2fd364" width=25% height=25%><img src="https://github.com/user-attachments/assets/3d4c8743-1554-4c80-b0d4-4c8f133a2f66" width=25% height=25%><img src="https://github.com/user-attachments/assets/7c70806a-dab5-4fd9-a833-6756707695d0" width=25% height=25%>

Users will tap the ‘+’ icon to the left of each habit once they’ve completed it. The results on the right side will add up accordingly to see a brief overview of their status. When a habit name is tapped on, the square becomes darkened and triggers the ‘Details View’ for that habit as seen below.

<img src="https://github.com/user-attachments/assets/bf0f086e-1903-4e4b-9d25-73076eeb9af9" width=25% height=25%><img src="https://github.com/user-attachments/assets/aab7e8a6-bd3b-44d2-92b7-a21043cae0b2" width=25% height=25%><img src="https://github.com/user-attachments/assets/74160b56-2ad6-4432-a1cc-6e3aba589b3a" width=25% height=25%>

Statistics for each habit are compiled through a business class and displayed on the "Details" screen above. This is also where users can delete habits from their account. 

<img src="https://github.com/user-attachments/assets/ce014414-ef04-4d26-9a3a-f8dde9c17676" width=25% height=25%><img src="https://github.com/user-attachments/assets/8c52fe7b-c172-474d-b731-75e4c371979a" width=25% height=25%>

The ‘Add Habit Form’ page allows users to add new habits and includes all data needed to add a new habit row to the database.
The ‘Activity Page’ gives users a visual representation of their progress for a single or multiple habits over a 7-day period. Tapping on the greyed-out habits will show/hide their corresponding-colored line on the chart at the top.

<h4>Project Risks</h4>
The core risk during the planning of this project was that I had no experience in Swift or mobile development in general at that point. I made sure to research documentation and know that the features I proposed in my planning were all feasible with the tech that I planned to use.

<h4>Non-Functional Requirement (NFR):</h4>
An NFR for the app will restrict the iPhones that are supported to iPhones 12-15 max and iOS 17+. The iOS requirement was chosen because of the possibility of adding a widget later on, which is only supported on iOS 17+.

<h4>Operational Support Design:</h4>
Logging will be supported through the API and will log errors, stack traces and important events including user account activity.

<h4>Development and Current State</h4>
There are a few features I would still like to flesh-out and continue to develop that are not complete at this point:
1. Navigation still needs to be fully implemented. 
2. Activity View doesn't currently calculate repetition differences from week to week. 
3. Certain features on the home page require a refresh to show results.
