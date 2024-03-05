# Conan's Test

This app runs a basic ts-node/prisma/express setup and has a very simple Flutter frontend within.

# Instructions to run

```
npm i
docker-compose up
cp .env.sample .env
npm run prisma:all
npm start
cd frontend
flutter run
```
