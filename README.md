# ShortyURL API Documentation

### ShortyURL is an application that takes a long URL and returns a short URL that redirects to the long URL. The purpose of this app is to prevent users from having to use super long URL's. Instead, they can utilize the app or this API and use the platform to create short and convenient links.

#### This API was built using Ruby on Rails.

### In order to use this full application, or to see the Website in Action, please get a CORS Blocker. Due to the nature of the fetch requests, CORS makes things not work. I used a Google Chrome extension called Moesif CORS which works very well.

## Live Hosted API : [https://shorty--url.herokuapp.com/](https://shorty--url.herokuapp.com/)

## Live Hosted Website : [https://shortyurl-frontend.herokuapp.com/](https://shortyurl-frontend.herokuapp.com/)

## Fetch Request

- In order to get access to data, we need to fetch from a list of all current links. You can use this fetch to generate views on your UI, or you can use this data to compare.

    - Example fetch request :
         
        ```
        fetch("https://shorty--url.herokuapp.com/")
        .then(resp => resp.json())
        .then(json => {
            this.setState({
                links: json
            })
        })
        .catch(err => console.log(err))

## POST Requests

- In order to insert data into the database, and in return, get a smaller URL back, we need to create a POST request.

    - Example POST Request :

    ```
    onFormSubmit = (event) => {
        event.preventDefault()

        let input_url = event.target[0].value

        fetch('https://shorty--url.herokuapp.com/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json'},
            body: JSON.stringify({ original_url : input_url})
        })
        .then(resp => resp.json())
        .then(json => {
            json.message ? this.setState({
                error_message: json.message
            }) : this.setState ({
                    current_short_link: json.shorten,
                    links: json.all
                })
            })
        .catch(error => console.log(error))
    }
    ```
    ### This particular POST request passes a body containing the Long URL that the user entered. The backend takes that URL, cleans it up by making sure all URL's that are similar end up the same. e.g. www.google.com and google.com will be entered once, instead of twice. In return, the database sends back the most recent URL that was entered into the system, and also returns an updated version of all the Links in the database. If there is an error, the database sends back a message. There is also a message for duplicates.

## DELETE Request

- There is a possibility to add a delete request to remove a link from the database that may not be in use anymore, or is no longer needed.

    - Example DELETE reqeuest :

    ```
    onDeleteButtonClick = (link) => {

        fetch('https://shorty--url.herokuapp.com/delete/' + link.short_url, {
            method: 'DELETE'
        })
        .then(resp => resp.json())
        .then(json => this.setState({
            links: json.all
        }))
        .catch(error => console.log(error))
    }
    ```

    ### To delete an item from the database, the route calls to use /delete/:short_url . This means that our unique identifier is a randomly generated 6 figure string. We use that string to find the item in our database that needs to be removed. The response is an updated JSON file with the most recent items in the database.

# API built by Vadim Stakhnyuk