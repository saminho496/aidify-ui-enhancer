
import { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { 
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { motion } from "framer-motion";
import { 
  Accessibility, 
  Mic, 
  MessageSquare, 
  Languages, 
  Eye,
  User,
  Settings,
  HelpCircle,
  LogOut
} from "lucide-react";

const Dashboard = () => {
  const [isLoaded, setIsLoaded] = useState(false);
  const navigate = useNavigate();
  
  useEffect(() => {
    setIsLoaded(true);
  }, []);
  
  return (
    <div className="min-h-screen bg-background flex flex-col">
      <header className="w-full p-4 border-b border-border/40 flex justify-between items-center">
        <div className="flex items-center gap-2">
          <div className="h-9 w-9 rounded-lg bg-gradient-to-br from-aidify-blue to-aidify-purple flex items-center justify-center">
            <Accessibility className="text-white h-5 w-5" />
          </div>
          <span className="font-semibold text-xl">Aidify</span>
        </div>
        
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-9 w-9 rounded-full p-0">
              <Avatar className="h-9 w-9">
                <AvatarImage src="https://github.com/shadcn.png" />
                <AvatarFallback>JD</AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-56">
            <DropdownMenuLabel>My Account</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>
              <User className="mr-2 h-4 w-4" />
              <span>Profile</span>
            </DropdownMenuItem>
            <DropdownMenuItem>
              <Settings className="mr-2 h-4 w-4" />
              <span>Settings</span>
            </DropdownMenuItem>
            <DropdownMenuItem>
              <HelpCircle className="mr-2 h-4 w-4" />
              <span>Help & Support</span>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => navigate("/")}>
              <LogOut className="mr-2 h-4 w-4" />
              <span>Log out</span>
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </header>
      
      <main className="flex-1 p-4 md:p-8 max-w-6xl mx-auto w-full">
        <section className="mb-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={isLoaded ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.5 }}
          >
            <h1 className="text-3xl font-bold mb-2">Welcome back, John</h1>
            <p className="text-muted-foreground">
              What would you like to do today?
            </p>
          </motion.div>
        </section>
        
        <section>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                animate={isLoaded ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.5, delay: 0.1 * index }}
              >
                <Link to={feature.path} className="block h-full">
                  <div className="feature-card h-full flex flex-col">
                    <div className="feature-icon-wrapper" style={{ backgroundColor: feature.color }}>
                      <feature.icon className="feature-icon" />
                    </div>
                    
                    <h2 className="text-xl font-semibold mb-3">{feature.title}</h2>
                    <p className="text-muted-foreground mb-5 flex-1">{feature.description}</p>
                    
                    <div className="mt-auto">
                      <Button className="w-full" style={{ backgroundColor: feature.color }}>
                        Open {feature.title}
                      </Button>
                    </div>
                  </div>
                </Link>
              </motion.div>
            ))}
          </div>
        </section>
        
        <section className="mt-12">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={isLoaded ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.5, delay: 0.6 }}
            className="glass-card p-6 rounded-xl"
          >
            <h2 className="text-xl font-semibold mb-4">Recent Activity</h2>
            <div className="space-y-4">
              {recentActivity.length > 0 ? (
                recentActivity.map((activity, index) => (
                  <div 
                    key={index} 
                    className="flex items-center p-3 rounded-lg border border-border/40 bg-background/50"
                  >
                    <div className="h-10 w-10 rounded-full flex items-center justify-center" style={{ backgroundColor: activity.color + "20" }}>
                      <activity.icon className="h-5 w-5" style={{ color: activity.color }} />
                    </div>
                    <div className="ml-4">
                      <p className="font-medium">{activity.title}</p>
                      <p className="text-sm text-muted-foreground">{activity.time}</p>
                    </div>
                  </div>
                ))
              ) : (
                <div className="text-center py-8">
                  <p className="text-muted-foreground">No recent activity yet</p>
                </div>
              )}
            </div>
          </motion.div>
        </section>
      </main>
    </div>
  );
};

const features = [
  {
    title: "Text to Speech",
    description: "Convert written text into spoken words with natural-sounding voices in multiple languages.",
    icon: MessageSquare,
    color: "#1E88E5",
    path: "/text-to-speech"
  },
  {
    title: "Speech to Text",
    description: "Accurately transcribe spoken words into written text in real-time with high accuracy.",
    icon: Mic,
    color: "#6C63FF",
    path: "/speech-to-text"
  },
  {
    title: "Translation",
    description: "Translate text between multiple languages instantly with support for over 50 languages.",
    icon: Languages,
    color: "#00BCD4",
    path: "/translation"
  },
  {
    title: "Object Detection",
    description: "Identify and describe objects in the real world using your camera with AI-powered recognition.",
    icon: Eye,
    color: "#FF5252",
    path: "/object-detection"
  }
];

const recentActivity = [
  {
    title: "Translated document from English to Spanish",
    time: "Today, 2:30 PM",
    icon: Languages,
    color: "#00BCD4"
  },
  {
    title: "Converted speech to text (2 minutes)",
    time: "Yesterday, 4:15 PM",
    icon: Mic,
    color: "#6C63FF"
  },
  {
    title: "Generated audio from article",
    time: "Yesterday, 10:20 AM",
    icon: MessageSquare,
    color: "#1E88E5"
  }
];

export default Dashboard;
