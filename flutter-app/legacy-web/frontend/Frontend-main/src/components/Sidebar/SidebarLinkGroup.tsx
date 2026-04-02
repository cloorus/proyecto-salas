import { ReactNode, useState } from 'react';

// Definition of the props that the SidebarLinkGroup component accepts
interface SidebarLinkGroupProps {
  children: (handleClick: () => void, open: boolean) => ReactNode;
  activeCondition: boolean;
}

// Definition of the SidebarLinkGroup component
const SidebarLinkGroup = ({
  children,
  activeCondition,
}: SidebarLinkGroupProps) => {
  const [open, setOpen] = useState<boolean>(activeCondition); // State to handle whether the SidebarLinkGroup is open or closed

  // Function that changes the state of 'open' when the user clicks
  const handleClick = () => {
    setOpen(!open);
  };

  return <li>{children(handleClick, open)}</li>;
};

// Export de component
export default SidebarLinkGroup;
