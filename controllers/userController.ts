import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

// Function to get all activities for a user
export async function getActivitiesForUser(req, res) {
  // Or use req.user.id if you're getting the ID from a JWT token
  const { userId } = req.user;

  try {
    const activities = await prisma.activity.findMany({
      where: { userId: Number(userId) },
      // You can also include other models here, e.g., include: { category: true }
    });
    res.json(activities);
  } catch (error) {
    res
      .status(500)
      .send(`Error fetching activities for user: ${error.message}`);
  }
}

// Function to toggle the 'completed' status of an activity
export async function toggleActivityCompleted(req, res) {
  const { id } = req.params;
  const { on } = req.body;

  try {
    const activity = await prisma.activity.findUnique({
      where: { id: Number(id) },
    });

    if (!activity) {
      return res.status(404).send("Activity not found");
    }

    const updatedActivity = await prisma.activity.update({
      where: { id: Number(id) },
      data: { completed: on },
    });

    res.json(updatedActivity);
  } catch (error) {
    res.status(500).send(`Error updating activity: ${error.message}`);
  }
}
