// The properties that the component receives are defined
interface BreadcrumbProps {
  pageName: string;
}

// Component that displays the name of the page
const Breadcrumb = ({ pageName }: BreadcrumbProps) => {
  return (
    <div className="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
      <h2 className="text-title-md2 font-semibold text-black dark:text-white">
        {pageName}
      </h2>
      <nav>
        <ol className="flex items-center gap-2">
        </ol>
      </nav>
    </div>
  );
};

// Export the component
export default Breadcrumb;
