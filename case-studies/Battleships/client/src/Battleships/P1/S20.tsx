import React from 'react';

import * as Roles from './Roles';
import {
    State,
    ReceiveState,
    SendState,
    TerminalState,
} from './EFSM';

import {
    MaybePromise,
} from './Types';

import {
    ReceiveHandler
} from './Session';

import { Config } from "../../Models";
import { Location } from "../../Models";


// ==================
// Message structures
// ==================

enum Labels {
    Winner = 'Winner', Hit = 'Hit', Miss = 'Miss', Sunk = 'Sunk',
}

interface WinnerMessage {
    label: Labels.Winner,
    payload: [Location],
};
interface HitMessage {
    label: Labels.Hit,
    payload: [Location],
};
interface MissMessage {
    label: Labels.Miss,
    payload: [Location],
};
interface SunkMessage {
    label: Labels.Sunk,
    payload: [Location],
};


type Message = | WinnerMessage | HitMessage | MissMessage | SunkMessage

// ===============
// Component types
// ===============

type Props = {
    register: (role: Roles.Peers, handle: ReceiveHandler) => void
};

/**
 * __Receives from Svr.__ Possible messages:
 *
 * * __Winner__(Location)
 * * __Hit__(Location)
 * * __Miss__(Location)
 * * __Sunk__(Location)
 */
export default abstract class S20<ComponentState = {}> extends React.Component<Props, ComponentState>
{

    componentDidMount() {
        this.props.register(Roles.Peers.Svr, this.handle.bind(this));
    }

    handle(message: any): MaybePromise<State> {
        const parsedMessage = JSON.parse(message) as Message;
        switch (parsedMessage.label) {
            case Labels.Winner: {
                const thunk = () => TerminalState.S18;

                const continuation = this.Winner(...parsedMessage.payload);
                if (continuation instanceof Promise) {
                    return new Promise((resolve, reject) => {
                        continuation.then(() => {
                            resolve(thunk());
                        }).catch(reject);
                    })
                } else {
                    return thunk();
                }
            } case Labels.Hit: {
                const thunk = () => ReceiveState.S21;

                const continuation = this.Hit(...parsedMessage.payload);
                if (continuation instanceof Promise) {
                    return new Promise((resolve, reject) => {
                        continuation.then(() => {
                            resolve(thunk());
                        }).catch(reject);
                    })
                } else {
                    return thunk();
                }
            } case Labels.Miss: {
                const thunk = () => ReceiveState.S21;

                const continuation = this.Miss(...parsedMessage.payload);
                if (continuation instanceof Promise) {
                    return new Promise((resolve, reject) => {
                        continuation.then(() => {
                            resolve(thunk());
                        }).catch(reject);
                    })
                } else {
                    return thunk();
                }
            } case Labels.Sunk: {
                const thunk = () => ReceiveState.S21;

                const continuation = this.Sunk(...parsedMessage.payload);
                if (continuation instanceof Promise) {
                    return new Promise((resolve, reject) => {
                        continuation.then(() => {
                            resolve(thunk());
                        }).catch(reject);
                    })
                } else {
                    return thunk();
                }
            }
        }
    }

    abstract Winner(payload1: Location,): MaybePromise<void>;
    abstract Hit(payload1: Location,): MaybePromise<void>;
    abstract Miss(payload1: Location,): MaybePromise<void>;
    abstract Sunk(payload1: Location,): MaybePromise<void>;

}