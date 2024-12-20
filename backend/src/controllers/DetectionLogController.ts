//import prisma client
import prisma from "../../prisma/client";

/**
 * Getting all detection log
 */
export async function getDetectionLogs() {
    try {
        //get all detection log
        const detectionLogs = await prisma.detection_Log.findMany({
            orderBy: { id: "asc" },
            select: {
                id: true,
                face: true,
                faceRelation: {
                    select: {
                        singlePictures: {
                            select: {
                                path: true,
                            },
                        },
                    },
                },
            },
        });

        //return response json
        return {
            success: true,
            message: "List Data Detection Log!",
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(`Error getting detection log: ${e}`);
    }
}

export async function getDetailDetectionLogs() {
    try {
        const detectionLogs = await prisma.detection_Log.findMany({
            select: {
                id: true,
                face: true,
                faceRelation: {
                    select: {
                        identity: true,
                        singlePictures: {
                            select: {
                                path: true,
                            },
                        },
                        identities: {
                            select: {
                                name: true,
                            },
                        },
                    },
                },
                timestamp: true,
            },
        });
        const recognized = detectionLogs.filter(
            (log) => log.faceRelation.identity !== null
        );
        const unrecognized = detectionLogs.filter(
            (log) => log.faceRelation.identity === null
        );

        return {
            success: true,
            message: "List Data Detail Detection Log!",
            recognized,
            unrecognized,
        };
    } catch (e: unknown) {
        console.error(`Error getting detection log: ${e}`);
    }
}

/**
 * Creating a detection log
 */
export async function createDetectionLog(options: { face: number }) {
    try {
        const detectionLogs = await prisma.detection_Log.create({
            data: {
                face: options.face,
            },
        });
        return {
            success: true,
            message: "Detection Log Created Successfully!",
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(`Error creating detection log: ${e}`);
        return {
            success: false,
            message: "Failed to create detection log",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

export async function createManyDetectionLog(options: { face: number[] }) {
    try {
        const detectionLogs = await prisma.detection_Log.createMany({
            data: options.face.map((face) => ({ face })),
        });
        return {
            success: true,
            message: "Detection Logs Created Successfully!",
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(`Error creating detection log: ${e}`);
        return {
            success: false,
            message: "Failed to create detection log",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

export async function getDetectionLogIdentity(id: string) {
    try {
        const identityy = await prisma.identity.findUnique({
            where: { id: parseInt(id) },
            select: {
                name: true,
                faces: {
                    select: {
                        id: true,
                        identity: true,
                    },
                },
            },
        });
        if (!identityy) {
            return {
                success: false,
                message: "Identity Not Found!",
                data: null,
            };
        }
        const faceIds = identityy.faces.map((face) => face.id);
        const detectionLogs = await prisma.detection_Log.findMany({
            where: {
                face: {
                    in: faceIds,
                },
            },
        });
        return {
            success: true,
            message: "List Data Detection Log by Identity!",
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(Error);
    }
}
/**
 * Getting a detection log by ID
 */
export async function getDetectionLogById(id: string) {
    try {
        const detectionLogId = parseInt(id);
        const detectionLogs = await prisma.detection_Log.findUnique({
            where: { id: detectionLogId },
        });

        if (!detectionLogs) {
            return {
                success: false,
                message: "Detection Log Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Detection Log Details for ID: ${id}`,
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(`Error getting detection log: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a detection log
 */
export async function updateDetectionLog(
    id: string,
    options: {
        face?: number;
    }
) {
    try {
        const detectionLogId = parseInt(id);
        const { face } = options;

        const detectionLogs = await prisma.detection_Log.update({
            where: { id: detectionLogId },
            data: {
                ...(face ? { face } : {}),
            },
        });

        return {
            success: true,
            message: "Detection Log Updated Successfully!",
            data: detectionLogs,
        };
    } catch (e: unknown) {
        console.error(`Error updating detection log: ${e}`);
        return {
            success: false,
            message: "Failed to update face",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

/**
 * Deleting a detection log
 */
export async function deleteDetectionLog(id: string) {
    try {
        const detectionLogId = parseInt(id);
        await prisma.detection_Log.delete({ where: { id: detectionLogId } });

        return {
            success: true,
            message: "Detection Log Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting detection log: ${e}`);
    }
}
