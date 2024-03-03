import { today } from "today.js";

function router(event) {
    const path = event.pathParameters?.path;
    if (path === "today") {
        return today();
    }
    return {
        status: 404,
        body: {
            ok: false,
            error: {
                code: "method_not_found",
                message: `The provided path has no ${event.httpMethod} method: ${event.path}`,
            },
        },
    }
}

export function handler(event, _context) {
    const response = router(event);
    return {
        statusCode: response.status,
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
        },
        isBase64Encoded: false,
        body: JSON.stringify(response.body),
    }
};
