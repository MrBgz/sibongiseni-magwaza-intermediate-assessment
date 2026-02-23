# Task Manager (Rails 7)

A Ruby on Rails 7 application for managing tasks with:
- task creation and listing
- marking tasks as completed
- deleting tasks
- basic weather display on the dashboard via WeatherAPI

## Tech Stack
- Ruby (see `.ruby-version`)
- Rails `~> 7.2.3`
- PostgreSQL
- RSpec + FactoryBot
- Hotwire (Turbo/Stimulus via Rails defaults)

## Prerequisites
- Ruby installed (matching `.ruby-version`)
- Bundler installed
- PostgreSQL running locally

## Environment Variables
This project uses `dotenv-rails`, so create a `.env` file in the project root.

Required for weather integration:

```bash
WEATHER_API_KEY=enter_api_key
```

If `WEATHER_API_KEY` is not set up, the app still runs and shows "Weather unavailable."

## Setup
1. Install dependencies:

```bash
bundle install
```

2. Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

## Run the Application
Start the Rails server:

```bash
bin/rails server
```

Open:
- `http://localhost:3000`

## Running Tests
Run the full RSpec suite:

```bash
bundle exec rspec
```

Run a specific spec file:

```bash
bundle exec rspec spec/services/weather_api/client_spec.rb
```

## Linting and Security Checks
Run RuboCop:

```bash
bin/rubocop
```

Run Brakeman:

```bash
bin/brakeman
```

## Application Routes
- `GET /` -> task dashboard (`tasks#index`)
- `POST /tasks` -> create task
- `PATCH /tasks/:id` -> mark task as completed
- `DELETE /tasks/:id` -> delete task

## Project Structure
- `app/models/task.rb`: task model and scopes
- `app/controllers/tasks_controller.rb`: task lifecycle actions
- `app/services/weather_api/client.rb`: weather API client wrapper
- `app/views/tasks/`: task dashboard and partials
- `spec/`: request/model/view/helper/service specs

## Notes
- Database schema is managed with Rails migrations (`db/migrate`).
- This project is configured for PostgreSQL in `config/database.yml`.
