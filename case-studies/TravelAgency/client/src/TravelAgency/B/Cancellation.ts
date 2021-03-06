// Cancellation.ts

import * as Roles from './Roles';

export enum Receive {
    NORMAL = 1000,
    SERVER_DISCONNECT = 1006,
    CLIENT_DISCONNECT = 4000,
    LOGICAL_ERROR = 4001,
    ROLE_OCCUPIED = 4002,
};

export enum Emit {
    NORMAL = 1000,
    LOGICAL_ERROR = 4001,
};

export interface Message {
    role: Roles.All
    reason?: any
};

export const toChannel = (role: Roles.All, reason?: any) => ({
    role,
    reason: reason instanceof Error ? reason.message : reason,
});