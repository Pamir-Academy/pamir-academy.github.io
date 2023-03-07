import { Manager } from "socket.io-client";

const manager = new Manager("http://::1");

const socket = manager.socket("/"); // main namespace
const page_pocket_packet_dot_markUP_nDOWN__ = manager.socket("/page"); // Page.namespace
const home = manager.socket("/home"); // home MD - Page.
const auth = manager.socket("/AUTH"); // MFA Handler. // OAUTH.
const adminSocket = manager.socket("/admin"); // admin namespace
