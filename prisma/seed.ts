import dotenv from "dotenv";
dotenv.config();

import { PrismaClient } from "@prisma/client";
import bcrypt from "bcrypt";

const prisma = new PrismaClient();

async function main() {
  // Seed Categories
  const relaxation = await prisma.category.create({
    data: { name: "Relaxation" },
  });
  const selfEsteem = await prisma.category.create({
    data: { name: "Self-Esteem" },
  });
  const productivity = await prisma.category.create({
    data: { name: "Productivity" },
  });
  // Add more categories as needed

  // Seed an Activity
  await prisma.activity.create({
    data: {
      title: "Lorem Ipsum Title",
      description: "Lorem ipsum dolor sit amet",
      categoryId: relaxation.id, // Example: Assigning this activity to the 'Relaxation' category
      duration: "30 minutes",
      difficultyLevel: "Easy",
      content: "This is a long text representing the content of the activity.",
    },
  });
  // Add more activities as needed
  const password = "securepassword";
  const hashedPassword = await bcrypt.hash(password, 10);

  // Seed a User
  await prisma.user.create({
    data: {
      username: "john_doe",
      email: "john@example.com",
      password: hashedPassword,
    },
  });
  // Add more users as needed
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
