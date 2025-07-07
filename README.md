 # CheckMe – Todo App

A simple **Todo List App** built with **Flutter** and developed in **Android Studio**.  
It allows users to add, manage, search, filter, and track their tasks easily.

## ✨ Features
**Core Todo App Functionality:**

1.  **Login Screen with Validations:**
    * Validate email address.
    * Validate password.
    * Navigate to the `homeScreen` upon successful login.

2.  **Home Screen (Todo Dashboard):**
    * Display a welcome message (with user's name and avatar, though avatar implementation might be optional based on design).
    * Show a list of todos (title + checkbox).
    * Use `ListView` for displaying todos.

3.  **Add Todo Feature:**
    * A Floating Action Button (FAB) to open a form.
    * Input fields for:
        * Todo title (required).
        * Optional description.
    * A "Save" button to add the todo to the list.

4.  **Mark as Done:**
    * A checkbox for each todo.
    * When checked, the todo should show a strikethrough or faded style.

5.  **Delete Todo:**
    * Long press *or* swipe to delete a todo.

6.  **Due Date:**
    * When creating a todo, allow setting a due date.
    * Display "Overdue" if the due date has passed.

7.  **Search Todos:**
    * A search bar to filter todos by title or description.

8.  **Todo Categories:**
    * Allow assigning todos to categories (e.g., "School", "Personal", "Urgent").
    * Implement filtering by category.

**New Updates / Technical Requirements:**

9.  **Riverpod State Management:**
    * Integrate the `flutter_riverpod` package.
    * **Replace all existing `setState()` logic** with Riverpod's Providers and State Notifiers.
    * Utilize both local and global state management with Riverpod.

10. **Theme Change:**
    * Implement functionality to switch between:
        * Dark mode
        * Light mode
        * System default theme

* **Todo Details Page:**
    * Tap on a todo to open a new screen showing its full details.
    * Include creation date.
    * Display full description.
    * An "Edit" button.


![loginscreen](screenshots/login.jpeg)
![a welcoming home screen for first login](screenshots/home.jpeg)
![Adding tasks](screenshots/addToDo.jpeg)
![selecting the due date](screenshots/DueDate.jpeg)
![Dashboard](screenshots/dashboard.jpeg)
 
