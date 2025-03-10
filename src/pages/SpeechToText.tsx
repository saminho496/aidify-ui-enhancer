
import { useState, useRef } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { ArrowLeft, Mic, MicOff, Copy, Save, Upload, RefreshCw } from "lucide-react";
import { toast } from "sonner";
import { motion } from "framer-motion";

const SpeechToText = () => {
  const [isRecording, setIsRecording] = useState(false);
  const [text, setText] = useState("");
  const [language, setLanguage] = useState("en-US");
  const [isLoading, setIsLoading] = useState(false);
  const [recordingTime, setRecordingTime] = useState(0);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  
  const handleRecord = () => {
    if (isRecording) {
      // Stop recording
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
      setIsRecording(false);
      toast.success("Recording stopped");
      
      // Simulate processing
      setIsLoading(true);
      setTimeout(() => {
        setText(prev => prev + (prev ? "\n\n" : "") + "This is a sample transcribed text to demonstrate the speech to text functionality. In a real application, this would be replaced with actual transcription from your microphone recording.");
        setIsLoading(false);
      }, 1500);
    } else {
      // Start recording
      setIsRecording(true);
      setRecordingTime(0);
      timerRef.current = setInterval(() => {
        setRecordingTime(prev => prev + 1);
      }, 1000);
      toast.info("Recording started");
    }
  };
  
  const handleCopyText = () => {
    if (!text.trim()) {
      toast.error("No text to copy");
      return;
    }
    
    navigator.clipboard.writeText(text)
      .then(() => toast.success("Text copied to clipboard"))
      .catch(() => toast.error("Failed to copy text"));
  };
  
  const handleSaveText = () => {
    if (!text.trim()) {
      toast.error("No text to save");
      return;
    }
    
    const blob = new Blob([text], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "transcription.txt";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    toast.success("Text saved to file");
  };
  
  const handleClearText = () => {
    if (!text.trim()) return;
    
    if (confirm("Are you sure you want to clear all text?")) {
      setText("");
      toast.info("Text cleared");
    }
  };
  
  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    // Only accept audio files
    if (!file.type.startsWith("audio/")) {
      toast.error("Please upload an audio file");
      return;
    }
    
    setIsLoading(true);
    toast.info("Processing audio file...");
    
    // Simulate processing
    setTimeout(() => {
      setText(prev => 
        prev + (prev ? "\n\n" : "") + 
        "This is a sample transcribed text from the uploaded audio file. In a real application, this would be replaced with actual transcription from your audio file."
      );
      setIsLoading(false);
      toast.success("Audio file processed successfully");
    }, 2000);
  };
  
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
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
            <span className="px-3 py-1 rounded-full bg-aidify-purple/10 text-aidify-purple text-sm font-medium">
              Speech to Text
            </span>
          </div>
          <h1 className="text-3xl font-bold mb-2">Convert Speech to Text</h1>
          <p className="text-muted-foreground">
            Record your voice or upload an audio file to convert to text
          </p>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
          className="space-y-6"
        >
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="glass-card p-6 rounded-xl md:col-span-1">
              <h2 className="text-lg font-semibold mb-4">Recording Options</h2>
              
              <div className="space-y-6">
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
                
                <Button 
                  className={`w-full ${isRecording ? 'bg-red-500 hover:bg-red-600' : 'bg-aidify-purple hover:bg-aidify-purple/90'}`}
                  onClick={handleRecord}
                >
                  {isRecording ? (
                    <>
                      <MicOff className="mr-2 h-5 w-5" />
                      Stop Recording
                    </>
                  ) : (
                    <>
                      <Mic className="mr-2 h-5 w-5" />
                      Start Recording
                    </>
                  )}
                </Button>
                
                {isRecording && (
                  <div className="text-center">
                    <span className="text-sm font-medium text-red-500">Recording: {formatTime(recordingTime)}</span>
                    <div className="mt-2 w-full bg-red-100 rounded-full h-1.5">
                      <div className="bg-red-500 h-1.5 rounded-full animate-pulse" style={{ width: `${Math.min(recordingTime / 180 * 100, 100)}%` }}></div>
                    </div>
                  </div>
                )}
                
                <div className="border-t border-border/40 pt-4">
                  <p className="text-sm text-muted-foreground mb-3">Or upload an audio file</p>
                  <label className="cursor-pointer w-full">
                    <input
                      type="file"
                      accept="audio/*"
                      className="hidden"
                      onChange={handleFileUpload}
                    />
                    <Button variant="outline" className="w-full">
                      <Upload className="mr-2 h-4 w-4" />
                      Upload Audio
                    </Button>
                  </label>
                </div>
              </div>
            </div>
            
            <div className="glass-card p-6 rounded-xl md:col-span-2">
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-lg font-semibold">Transcription</h2>
                
                <div className="flex gap-2">
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={handleCopyText}
                    disabled={!text.trim()}
                  >
                    <Copy className="h-4 w-4" />
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={handleSaveText}
                    disabled={!text.trim()}
                  >
                    <Save className="h-4 w-4" />
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={handleClearText}
                    disabled={!text.trim()}
                  >
                    <RefreshCw className="h-4 w-4" />
                  </Button>
                </div>
              </div>
              
              <div className="relative min-h-[300px]">
                <Textarea
                  placeholder={isLoading ? "Processing..." : "Your transcription will appear here..."}
                  className="min-h-[300px] resize-none"
                  value={text}
                  onChange={(e) => setText(e.target.value)}
                  disabled={isLoading}
                />
                
                {isLoading && (
                  <div className="absolute inset-0 flex items-center justify-center bg-background/50 backdrop-blur-sm">
                    <div className="flex flex-col items-center">
                      <div className="h-8 w-8 rounded-full border-4 border-aidify-purple/30 border-t-aidify-purple animate-spin"></div>
                      <span className="mt-3 text-sm font-medium">Processing audio...</span>
                    </div>
                  </div>
                )}
              </div>
              
              <div className="flex justify-between mt-2 text-xs text-muted-foreground">
                <span>{text.length} characters</span>
                <span>{text.split(/\s+/).filter(Boolean).length} words</span>
              </div>
            </div>
          </div>
        </motion.div>
      </main>
    </div>
  );
};

export default SpeechToText;
