import { Elysia } from "elysia";
import Routes from "./routes";
import swagger from "@elysiajs/swagger";

const app = new Elysia();

app.use(swagger());
app.get("/", () => "Hello Elysia!");
app.group("/api", (app) => app.use(Routes));
app.listen({
    hostname: "10.208.38.84", // change sesuai IP address
    port: 3000,
});

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
