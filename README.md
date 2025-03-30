![Docker](https://img.shields.io/badge/docker-ready-blue)
![Rails](https://img.shields.io/badge/rails-7.x-red)
![License](https://img.shields.io/badge/license-MIT-green)

# Rails Docker Template

This is a reusable Docker-based template for Ruby on Rails applications.  
It allows you to quickly spin up new Rails projects with PostgreSQL and Redis using Docker Compose.

---

## 🚀 Features

- 🐳 Dockerized setup (Rails, PostgreSQL, Redis)
- 🔄 Automatic app creation via script
- 📁 Separate development and production configs
- 🔧 Makefile with useful shortcuts (`make up`, `make db-backup`, etc.)
- 🔒 .env support for environment variables

---

## 📦 Requirements

Make sure the following tools are installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)
- `make` (usually preinstalled, otherwise install via package manager)

---

## 🧪 Usage

### 1. Clone this template

```bash
git clone https://github.com/yourname/rails-docker-template.git
cd rails-docker-template
```

### 2. Create a new Rails app from the template

```bash
./init-new-project.sh myapp 3201
cd /var/www/myapp
make up
```

- `myapp`: name of your new app
- `3201`: the port your app will be exposed on (e.g. http://localhost:3201)

### 3. Manage your app using Makefile

```bash
make up           # Build and start the app
make down         # Stop and remove containers
make rebuild      # Rebuild containers
make logs         # View app logs
make sh           # Open a bash shell inside the app container
make psql         # Connect to PostgreSQL via psql
make db-backup    # Create a backup of the database
make db-restore   # Restore database from backup.sql
```

---

## 🛠 Configuration

Copy `.env.example` to `.env` and fill in your secrets:

```bash
cp .env.example .env
```

Example:

```env
SECRET_KEY_BASE=your-actual-secret
```

You can generate a secret using:

```bash
rails secret
```

---

## 📁 Directory Structure

```
rails-docker-template/
├── bin/
│   └── docker-entrypoint         # Custom container entrypoint
├── Dockerfile                    # Rails app Dockerfile
├── docker-compose.yml            # Base Compose file
├── docker-compose.override.yml   # Local development overrides
├── docker-compose.prod.yml       # Production config
├── Makefile                      # App management commands
├── .env.example                  # Sample environment config
└── init-new-project.sh           # Script to generate new app from template
```

---

## 🧰 Recommended Workflow

1. Clone the template  
2. Run `init-new-project.sh` with app name and port  
3. Enter the new folder  
4. Run `make up`  
5. Start building your Rails app!

---

## 📃 License

MIT
