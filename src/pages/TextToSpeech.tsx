
import { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Slider } from "@/components/ui/slider";
import { Label } from "@/components/ui/label";
import { ArrowLeft, Play, Pause, Save, Volume2, Upload } from "lucide-react";
import { toast } from "sonner";
import { motion } from "framer-motion";

const TextToSpeech = () => {
  const [text, setText] = useState("");
  const [isPlaying, setIsPlaying] = useState(false);
  const [language, setLanguage] = useState("en-US");
  const [voice, setVoice] = useState("default");
  const [speed, setSpeed] = useState([1]);
  const [volume, setVolume] = useState([80]);
  const [isLoading, setIsLoading] = useState(false);
  
  const handlePlayPause = () => {
    if (!text.trim()) {
      toast.error("Please enter text to convert to speech");
      return;
    }
    
    setIsPlaying(!isPlaying);
    
    if (!isPlaying) {
      toast.success("Playing audio...");
    } else {
      toast.info("Audio paused");
    }
  };
  
  const handleSave = () => {
    if (!text.trim()) {
      toast.error("Please enter text to convert to speech");
      return;
    }
    
    setIsLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      toast.success("Audio saved successfully!");
      setIsLoading(false);
    }, 1500);
  };
  
  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    // Only accept text files
    if (file.type !== "text/plain") {
      toast.error("Please upload a text file (.txt)");
      return;
    }
    
    const reader = new FileReader();
    reader.onload = (e) => {
      const content = e.target?.result as string;
      setText(content);
      toast.success("File uploaded successfully!");
    };
    reader.readAsText(file);
  };
  
  return (
    <div className="min-h-screen flex flex-col">
      <header className="w-full p-4 border-b border-border/40 flex justify-between items-center">
        <Link to="/dashboard" className="inline-flex items-center text-sm font-medium transition-colors hover:text-primary">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Dashboard
        </Link>
      </header>
      
      <main className="flex-1 p-4 md:p-8 max-w-4xl mx-auto w-full">
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="mb-8"
        >
          <div className="inline-block mb-4">
            <span className="px-3 py-1 rounded-full bg-aidify-blue/10 text-aidify-blue text-sm font-medium">
              Text to Speech
            </span>
          </div>
          <h1 className="text-3xl font-bold mb-2">Convert Text to Speech</h1>
          <p className="text-muted-foreground">
            Enter text below to convert it to natural-sounding speech
          </p>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
          className="space-y-6"
        >
          <div className="glass-card p-6 rounded-xl">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-semibold">Enter Your Text</h2>
              <label className="cursor-pointer">
                <input
                  type="file"
                  accept=".txt"
                  className="hidden"
                  onChange={handleFileUpload}
                />
                <div className="flex items-center p-2 text-sm text-primary hover:text-primary/80">
                  <Upload className="h-4 w-4 mr-2" />
                  <span>Upload Text</span>
                </div>
              </label>
            </div>
            
            <Textarea
              placeholder="Type or paste your text here..."
              className="min-h-[200px] mb-4"
              value={text}
              onChange={(e) => setText(e.target.value)}
            />
            
            <div className="flex justify-end">
              <span className="text-xs text-muted-foreground">
                {text.length} characters
              </span>
            </div>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="glass-card p-6 rounded-xl">
              <h2 className="text-lg font-semibold mb-4">Voice Settings</h2>
              
              <div className="space-y-4">
                <div className="space-y-2">
                  <Label>Language</Label>
                  <Select value={language} onValueChange={setLanguage}>
                    <SelectTrigger>
                      <SelectValue placeholder="Select language" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="en-US">English (US)</SelectItem>
                      <SelectItem value="en-GB">English (UK)</SelectItem>
                      <SelectItem value="es-ES">Spanish</SelectItem>
                      <SelectItem value="fr-FR">French</SelectItem>
                      <SelectItem value="de-DE">German</SelectItem>
                      <SelectItem value="it-IT">Italian</SelectItem>
                      <SelectItem value="ja-JP">Japanese</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="space-y-2">
                  <Label>Voice</Label>
                  <Select value={voice} onValueChange={setVoice}>
                    <SelectTrigger>
                      <SelectValue placeholder="Select voice" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="default">Default</SelectItem>
                      <SelectItem value="male1">Male 1</SelectItem>
                      <SelectItem value="male2">Male 2</SelectItem>
                      <SelectItem value="female1">Female 1</SelectItem>
                      <SelectItem value="female2">Female 2</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>
            
            <div className="glass-card p-6 rounded-xl">
              <h2 className="text-lg font-semibold mb-4">Audio Settings</h2>
              
              <div className="space-y-6">
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <Label>Speed</Label>
                    <span className="text-sm text-muted-foreground">{speed[0]}x</span>
                  </div>
                  <Slider
                    value={speed}
                    min={0.5}
                    max={2}
                    step={0.1}
                    onValueChange={setSpeed}
                  />
                </div>
                
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <Label>Volume</Label>
                    <span className="text-sm text-muted-foreground">{volume[0]}%</span>
                  </div>
                  <Slider
                    value={volume}
                    min={0}
                    max={100}
                    step={1}
                    onValueChange={setVolume}
                  />
                </div>
              </div>
            </div>
          </div>
          
          <div className="flex flex-col sm:flex-row gap-4 mt-6">
            <Button 
              size="lg"
              className="w-full sm:w-auto bg-aidify-blue hover:bg-aidify-blue/90 text-white flex-1"
              onClick={handlePlayPause}
              disabled={!text.trim()}
            >
              {isPlaying ? (
                <>
                  <Pause className="mr-2 h-5 w-5" />
                  Pause
                </>
              ) : (
                <>
                  <Play className="mr-2 h-5 w-5" />
                  Play
                </>
              )}
            </Button>
            
            <Button 
              size="lg" 
              variant="outline" 
              className="w-full sm:w-auto flex-1"
              onClick={handleSave}
              disabled={!text.trim() || isLoading}
            >
              {isLoading ? (
                "Saving..."
              ) : (
                <>
                  <Save className="mr-2 h-5 w-5" />
                  Save Audio
                </>
              )}
            </Button>
          </div>
        </motion.div>
      </main>
    </div>
  );
};

export default TextToSpeech;
