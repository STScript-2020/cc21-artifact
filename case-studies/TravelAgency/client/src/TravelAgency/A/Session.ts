import React from 'react';

import {
    Constructor,
    DOMEvents,
    EventHandler,
    MaybePromise,
} from './Types';

import {
    State,
} from './EFSM';

import {
    Peers
} from './Roles';

export type SendComponentFactory<Payload> = <K extends keyof DOMEvents> (event: K, handler: EventHandler<Payload, K>) => Constructor<React.Component>;
export type SendComponentFactoryFactory = <Payload> (role: Peers, label: string, successor: State) => SendComponentFactory<Payload>;
export type ReceiveHandler = (message: any) => MaybePromise<State>;