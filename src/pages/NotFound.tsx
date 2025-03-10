
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";

const NotFound = () => {
  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-b from-background to-muted/30">
      <motion.div 
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5 }}
        className="text-center"
      >
        <div className="mb-6 w-20 h-20 mx-auto rounded-2xl bg-aidify-blue/10 flex items-center justify-center">
          <span className="text-aidify-blue text-4xl font-bold">404</span>
        </div>
        
        <h1 className="text-3xl font-bold mb-3">Page Not Found</h1>
        
        <p className="text-muted-foreground mb-6 max-w-md">
          We couldn't find the page you were looking for. The page might have been moved or doesn't exist.
        </p>
        
        <Link to="/">
          <Button size="lg" className="bg-gradient-to-r from-aidify-blue to-aidify-purple">
            Return to Home
          </Button>
        </Link>
      </motion.div>
    </div>
  );
};

export default NotFound;
