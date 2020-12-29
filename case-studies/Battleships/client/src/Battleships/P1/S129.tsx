import React from "react";

// ===============
// Component types
// ===============

type Props = {
    terminate: () => void,
};

/**
 * __Terminal state__.
 */
export default abstract class S129<ComponentState = {}> extends React.Component<Props, ComponentState> {

    componentDidMount() {
        this.props.terminate();
    }

}