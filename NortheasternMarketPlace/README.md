**Software Requirements Specification Document**
<br>
Group: Super Sentai<br>
Product: Northeastern Marketplace<br>
Northeastern Marketplace is a mobile application that connects Northeastern Students who are interested in buying and selling second hand items. <br><br>
**Section 1. Purpose**<br><br>
**1.1 Definitions**<br>
Buyers: Any user that is interested in making a purchase.<br>
Sellers: Any user looking to sell an item. <br>
Students: Specific to Northeastern students. <br>
Users: Students who sign up for the application, can interchange between buying and selling roles. <br>
Product: Any new or second hand items that are in working/ good condition. <br>
Privacy: our obligation to protect user data in a safe, secure, and ethical way. 
<br><br>
**1.2 Background** <br>
Students who are moving out of college often want to sell their tables, lights, etc.. Because there is no proper platform a lot of students leave behind many of their things and shift. This will be a place for students in NEU to buy and sell things. The students can communicate within themselves in the app, negotiate rates and meet at a place. Students can also post details about their house in case they are moving out and need to find a roommate. The app will be a platform for students to connect with each other and smoothen the process.<br>

**Section 2. Overall Description**<br><br>
**2.1 User Characteristics- Target: Northeastern University Students**<br>
- Live within some reasonable distance to their campus<br>
- As students, they might not have access to vehicles to travel to stores or faraway sellers. <br>
- Some students have limited budgets.<br>
- NEU students are environmentally conscious and do not want to throw away usable items. <br>
- Students feel safer trading with other students, as opposed to online strangers. <br><br>

**2.2 User Stories:** <br>
- As a student, I want to purchase items at reasonable prices<br>
- As a student, I want to buy an item that is of a usable/ good quality<br>
- As a student, I don’t want to travel too far to buy basic things<br>
- As a student, I don’t want to leave behind items once I graduate<br>
- As a seller, I want to sell my stuff as quickly as possible.<br>
- As a seller, I want to sell my stuff without being cheated.<br>

<br><br>
**2.3 App Workflow**<br>
![image](https://user-images.githubusercontent.com/109566163/233857536-78ea6689-0ae6-4684-a0b4-66618ef49ea0.png)
<br><br>
**Section 3. Requirements** <br><br>
**3.1 Functional**<br><br>
***3.1.1 User Registration and Authentication: The application should allow users to create an account, log in, and log out.*** <br><br>
The login page should give new users the options to create an account and be added onto our user base. <br>
The login process should display an error message to users if the information they entered is not found in our database, or does not match our records.<br>
The process for creating an account should ask users to verify their student credentials by providing an Northeastern University email account. <br>
The process for creating an account requires an NEU campus location<br>
The process for creating an account requires private or personal information, such as a valid address.<br>
The process for creating an account needs to support the creation of a username and password, which will facilitate all future activity on the app. This information can not be changed later on. <br>
Users will be asked to re-confirm their passwords for additional validation.<br><br>
***3.1.2 Search and Browse Listings: The application should allow users to sort and filter based on various criteria, such as category and price  to aid their decision making process.***<br><br> 
The Home Page should display randomized products, with the option to refresh the page to view more products. This should facilitate an engaging experience for the user and provide them with opportunities to interact with products that they might have not otherwise sought out. <br>
Every available product in our database should show up in the Market/ Products page.<br> 
Users should be able to click on a specific item to view more detailed information about that product listing. <br>
The individual product pages should display the starting price of the item, but provide users with the option to renegotiate the price with the seller through our chat feature. <br><br>
***3.1.3 Posting Listings: The application should allow users to post new listings for items they want to sell. Users should be able to provide detailed information about the item, including price, condition, and photos.***<br><br>
The application will guide sellers through a posting process using an intuitive form.<br>
Users must provide a concise product name, a brief description of the product, a starting price, and a pick up address.<br>
Sellers should also identify the category and current condition of the item.<br> 
Sellers will have the option to upload an image of the product from their local devices.<br>
Private information, such as location, should not be shared in the actual listing. <br>
Sellers will be able to view their previous postings through the Homepage. The Products available page will show all of their posts, which have yet to be sold. Once an exchange is confirmed between two parties, the seller is responsible for marking the product as sold through this page. <br>
The Products sold page will show all of a seller’s previously sold items. They can use this page as reference for pricing items in the future. <br><br>
***3.1.4 Communication and Negotiation: The application should provide a way for buyers and sellers to communicate and negotiate the terms of the sale.***<br><br> 
Every user should have access to a history of previous and ongoing chat messages. <br> 
Users should be able to search through their previous conversation logs by looking up a specific username. <br>
The Chat history page will provide all of the conversation logs (previous and ongoing chats) between the logged in user and some other user in our user base. The username of the other NEU Marketplace user should be displayed, as well as the most recent message in that chat conversation. <br>
Conversation logs should be automatically sorted based on recency. <br>
Users should be able to enter a specific chat in the conversation log by clicking on that message interaction.<br>
Chat pages should display the timestamp of the most recent message, and there should be clear distinction between which user sent the message. For example, the current logged in user should have their chat bubble aligned towards the right side of the screen, while the other user’s messages are aligned towards the left side of the screen- standard messaging interface practices. <br>
When a new message is sent, that message should be automatically loaded into the chat screen.<br>
Users should be given the option to view the profile of the other user they are chatting with. <br><br>
***3.1.5 User profile information: The application should support a Private Profile page and a Public Profile page. The current logged in user will be the only ones who have access to their private profiles. All logged in users can view each other's public profile page.***<br><br>
The private profile page should display public and personal information, such as the logged in user’s full name, their campus, their NEU email address, and their current address. <br>
The current logged in user can edit their account information through a separate form. The user should be able to cancel their edits if they do not want the new changes to be saved. <br>
Address information should be optional. Edits to the full name, NEU email, and campus information must be validated. For example, users can only select a valid NEU campus from the form’s drop down menu.<br> <br>
**3.2 Non-functional**<br><br>
***3.2.1 Date, Privacy, and Security: The application should be designed to protect user data, including personal information and any other sensitive data.***<br><br> 
The system should protect users' privacy information by limiting accessibility to user information. <br>
Public profiles will only share minimal information about a specific user, meaning their profile picture, their username, first name, and NEU campus. We selected these fields to provide more familiarity between two users during messaging interactions and potential exchanges. <br>
Data changes and updates must persist in the online database. This must be considered when making updates to any data in our collection.<br> 
In order to save any changes made during the editing session (edit account form), the user must re-enter their password to confirm and submit their changes. <br>
The application might require access to the user’s personal device for selecting images for their profile picture or during the creation of a new product listing. The application will only extract the file that the user specifies, not taking any additional information from their device that might breach the user’s privacy. <br><br>
***3.2.2 Accessibility and Assistive Technology:  The application should be designed to be accessible to users with disabilities. It should conform to accessibility guidelines to ensure that all users can access the application.***<br><br>
The application should support assistive technology such as screen readers. <br>
Tooltips can be used to give context for navigational buttons or interactive widgets. This can be used interchangeably with semantic labels, as both are recognized by screen readers. <br>
Empty text fields should provide a default hint message that gives instructions to users for how to interact with it.  <br>
The application should provide sufficient color contrast between text and background to make it easy for users with visual impairments to read.<br>
The application should provide consistent navigation throughout.<br>
The application should be compatible with a variety of devices and platforms. <br><br>

**4. Wireframes** <br><br>
https://github.com/CS5520-Seattle-Spring23/final-project-super-santai/blob/d5f99392d07cdb290f9dfc615f2c6ff56e07bac6/Hi-Fi%20Wireframes_Super%20Sentai.pdf
<br><br>

**5. UML Class Diagram**<br>
![image](https://user-images.githubusercontent.com/109566163/233857706-210de0db-4af3-423f-94c1-63bdcd758b45.png)

**6. Gantt Diagram**<br>
<img width="618" alt="image" src="https://user-images.githubusercontent.com/47215795/227046408-0e2e2c94-5675-4784-8eff-bf97d0d9c6ce.png">

**7. Traceability Matrix**

https://docs.google.com/document/d/1AY_d8F9pjBaohWulsGagbIR97dEG-zU3RrrtUWmQvxk/edit?usp=sharing <br>

**8. Pain Point** <br>
Due to our limited experience, we had to sacrifice some of the functionalities of our app in order to make time for key functionalities. We believe that our initial design was a bit too ambitious, and the actual implementation was more difficult than previously expected. In order to make sure that the core logic of our app worked, we needed to scrap some of our more challenging features. Furthermore, we ran into some problems syncing up our enviornment configurations, working separately on different devices in parallel, and making sure that our code ran on without issue on everyone's versions. Lastly, our biggest challenge was scheduling meeting times to flesh out our ideas together as a group. Delegating tasks can only work so well, if not everyone is on the same page. Communication is paramount in a group project like this, but it is really difficult when everyone has their individual school/ work/ and personal schedules outside of the class. Despite this, we completed this project to the best of our abilities and learned a lot from this experience. 

