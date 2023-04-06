## players-api

### Set Up
1. Ensure you have `docker` and `docker-compose` installed.
2. To run the app, run
```bash
$ docker-compose up -d
```

### Running Step 1 of the Project
Execute the following commands
```bash
$ docker exec -it players-api-app-1 bundle exec rails c
> FetchPlayersJob.perform_now # to run the job immediately
> FetchPlayersJob.perform_later # to enqueue the job and let the sidekiq worker do its job
> exit # to exit the rails console
```
This job will also run every 5 minutes. That interval may be excessive, but it was
intentionally kept short for the sake of this demo project.

### Running Step 2 of the Project
Make the following HTTP request using your favorite HTTP client:
```bash
$ curl http://localhost:3000/players/2142052
```
This will return the Patrick Mahomes sample response in the instructions

### Running Step 3 of the Project
Make the following HTTP request using your favorite HTTP client:
```bash
$ curl http://localhost:3000/players?sport=football&age=25-27&position=QB&last_initial=M
```
This will return an array of results looking like the result from step 2,
but it'll contain more than Patrick Mahomes. Specifically Kyler Murray,
Baker Mayfield, and a few others.

Any combination of these query params could be used for the above endpoint. 

NOTE: The `age` query param could also just take a single number, i.e. `27`
if you wanted to query by a specific age instead of an age range.

## Project Instructions

To get a base level understanding of how you approach real life problems, we’d like you to complete this small code challenge. We don’t want to waste your time, so while we’re interested in how you can tackle this creatively, we don’t want you to use more than 3 or 4 hours. We’re interested in how you structure your code for organization and extensibility purposes as well clarity.

### Step 1

Import and persist the players from the following CBS API for baseball, football, and basketball. This should be build in a way where data can be periodically imported and update existing records in the database

[http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON](http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON)

### Step 2

Create a JSON API endpoint for a player. Like seen below:

```json
{
  "id": "123",
  "name_brief": "P. Mahomes",
  "first_name": "Patrick",
  "last_name": "Mahomes",
  "position": "QB",
  "age": "26",
  "average_position_age_diff": "1"
}
```

---

Each element in the JSON should be self explanatory except for the following two:

- `name_brief`
    - For football players it should be the first initial and their last name like “P. Manning”.
    - For basketball players it should be first name plus last initial like “Kobe B.”.
    - For baseball players it should just be the first initial and the last initial like “G. S.”.
- `average_position_age_diff`
    - This value should be the difference between the age of the player vs the average age for the player’s position.

### Step 3

Create a basic search JSON API endpoint that will return player data shown in Step 2 for all players found based on any combination of the following parameters:

- Sport
- First letter of last name
- A specific age (ex. 25)
- A range of ages (ex. 25 - 30)
- The player’s position (ex: “QB”)
