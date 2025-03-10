
import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";
import { useIsMobile } from "@/hooks/use-mobile";
import { Accessibility, Mic, MessageSquare, Languages, Eye } from "lucide-react";

const Welcome = () => {
  const [loaded, setLoaded] = useState(false);
  const isMobile = useIsMobile();
  
  useEffect(() => {
    setLoaded(true);
  }, []);

  return (
    <div className="min-h-screen flex flex-col">
      <header className="w-full p-4 flex justify-between items-center border-b border-border/40">
        <div className="flex items-center gap-2">
          <div className="h-9 w-9 rounded-lg bg-gradient-to-br from-aidify-blue to-aidify-purple flex items-center justify-center">
            <Accessibility className="text-white h-5 w-5" />
          </div>
          <span className="font-semibold text-xl">Aidify</span>
        </div>
        <div className="flex gap-2">
          <Link to="/login">
            <Button variant="ghost">Login</Button>
          </Link>
          <Link to="/signup">
            <Button>Sign Up</Button>
          </Link>
        </div>
      </header>
      
      <main className="flex-1 p-4 md:p-8 flex flex-col items-center justify-center text-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={loaded ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.5 }}
          className="max-w-2xl px-4"
        >
          <div className="mb-4 inline-block">
            <span className="px-3 py-1 rounded-full bg-primary/10 text-primary text-sm font-medium">
              Accessibility for Everyone
            </span>
          </div>
          
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 leading-tight">
            Your personal assistant for
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-aidify-blue to-aidify-purple"> accessibility</span>
          </h1>
          
          <p className="text-lg md:text-xl text-muted-foreground mb-8 max-w-lg mx-auto">
            Aidify helps specially-abled users with speech-to-text, text-to-speech, translation, and object detection.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link to="/signup">
              <Button size="lg" className="w-full sm:w-auto bg-gradient-to-r from-aidify-blue to-aidify-purple hover:opacity-90 transition-all">
                Get Started
              </Button>
            </Link>
            <Link to="/login">
              <Button size="lg" variant="outline" className="w-full sm:w-auto">
                Sign In
              </Button>
            </Link>
          </div>
        </motion.div>
        
        <motion.div 
          initial={{ opacity: 0 }}
          animate={loaded ? { opacity: 1 } : {}}
          transition={{ duration: 0.5, delay: 0.3 }}
          className="mt-16 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 w-full max-w-4xl"
        >
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 20 }}
              animate={loaded ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: 0.4 + index * 0.1 }}
              className="feature-card"
            >
              <div className="feature-icon-wrapper" style={{ backgroundColor: feature.color }}>
                <feature.icon className="feature-icon" />
              </div>
              <h3 className="text-lg font-medium mb-2">{feature.title}</h3>
              <p className="text-muted-foreground text-sm">{feature.description}</p>
            </motion.div>
          ))}
        </motion.div>
      </main>
      
      <footer className="p-6 border-t border-border/40 text-center text-muted-foreground">
        <p className="text-sm">© {new Date().getFullYear()} Aidify. All rights reserved.</p>
      </footer>
    </div>
  );
};

const features = [
  {
    title: "Text to Speech",
    description: "Convert written text into spoken words with natural-sounding voices",
    icon: MessageSquare,
    color: "#1E88E5"
  },
  {
    title: "Speech to Text",
    description: "Accurately transcribe spoken words into written text in real-time",
    icon: Mic,
    color: "#6C63FF"
  },
  {
    title: "Translation",
    description: "Translate text between multiple languages with high accuracy",
    icon: Languages,
    color: "#00BCD4"
  },
  {
    title: "Object Detection",
    description: "Identify and describe objects in the real world using your camera",
    icon: Eye,
    color: "#FF5252"
  }
];

export default Welcome;
