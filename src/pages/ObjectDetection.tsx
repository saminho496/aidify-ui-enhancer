
import { useState, useRef } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { 
  ArrowLeft, 
  Camera, 
  Upload, 
  RefreshCw,
  Play, 
  Volume2, 
  VolumeX,
  ZoomIn,
  ZoomOut
} from "lucide-react";
import { toast } from "sonner";
import { motion } from "framer-motion";

const ObjectDetection = () => {
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [isDetectionComplete, setIsDetectionComplete] = useState(false);
  const [audioEnabled, setAudioEnabled] = useState(true);
  const [detectedObjects, setDetectedObjects] = useState<{ label: string; confidence: number; color: string }[]>([]);
  const [zoomLevel, setZoomLevel] = useState(1);
  
  const fileInputRef = useRef<HTMLInputElement>(null);
  const videoRef = useRef<HTMLVideoElement>(null);
  
  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    // Only accept image files
    if (!file.type.startsWith("image/")) {
      toast.error("Please upload an image file");
      return;
    }
    
    const reader = new FileReader();
    reader.onload = (e) => {
      const result = e.target?.result as string;
      setImagePreview(result);
      setIsDetectionComplete(false);
      setDetectedObjects([]);
      
      // Process the image
      processImage();
    };
    reader.readAsDataURL(file);
  };
  
  const handleCapturePhoto = () => {
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      if (videoRef.current && videoRef.current.srcObject) {
        // Stop current stream
        const mediaStream = videoRef.current.srcObject as MediaStream;
        mediaStream.getTracks().forEach(track => track.stop());
        videoRef.current.srcObject = null;
        return;
      }
      
      toast.info("Accessing camera...");
      
      navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
          if (videoRef.current) {
            videoRef.current.srcObject = stream;
            videoRef.current.play();
          }
        })
        .catch(err => {
          console.error("Error accessing camera:", err);
          toast.error("Could not access camera. Please check permissions.");
        });
    } else {
      toast.error("Camera access is not supported in your browser");
    }
  };
  
  const takeSnapshot = () => {
    if (videoRef.current) {
      const canvas = document.createElement("canvas");
      canvas.width = videoRef.current.videoWidth;
      canvas.height = videoRef.current.videoHeight;
      const ctx = canvas.getContext("2d");
      
      if (ctx) {
        ctx.drawImage(videoRef.current, 0, 0, canvas.width, canvas.height);
        const dataUrl = canvas.toDataURL("image/png");
        setImagePreview(dataUrl);
        
        // Stop the camera
        const mediaStream = videoRef.current.srcObject as MediaStream;
        mediaStream.getTracks().forEach(track => track.stop());
        videoRef.current.srcObject = null;
        
        // Process the image
        processImage();
      }
    }
  };
  
  const processImage = () => {
    setIsProcessing(true);
    setIsDetectionComplete(false);
    
    // Simulate API call for object detection
    setTimeout(() => {
      // Generate random objects for demo
      const randomObjects = [
        { label: "Person", confidence: 0.96, color: "#FF5252" },
        { label: "Chair", confidence: 0.89, color: "#1E88E5" },
        { label: "Table", confidence: 0.78, color: "#6C63FF" },
        { label: "Book", confidence: 0.72, color: "#00BCD4" },
        { label: "Laptop", confidence: 0.94, color: "#4CAF50" }
      ];
      
      // Take 2-4 random objects from the list
      const count = Math.floor(Math.random() * 3) + 2;
      const selectedObjects = [];
      const usedIndices = new Set<number>();
      
      while (selectedObjects.length < count) {
        const index = Math.floor(Math.random() * randomObjects.length);
        if (!usedIndices.has(index)) {
          usedIndices.add(index);
          selectedObjects.push({
            ...randomObjects[index],
            confidence: Math.round((0.65 + Math.random() * 0.30) * 100) / 100
          });
        }
      }
      
      setDetectedObjects(selectedObjects);
      setIsProcessing(false);
      setIsDetectionComplete(true);
      
      if (audioEnabled) {
        toast.success("Objects detected!");
      }
    }, 2000);
  };
  
  const resetDetection = () => {
    setImagePreview(null);
    setIsDetectionComplete(false);
    setDetectedObjects([]);
    
    if (videoRef.current && videoRef.current.srcObject) {
      const mediaStream = videoRef.current.srcObject as MediaStream;
      mediaStream.getTracks().forEach(track => track.stop());
      videoRef.current.srcObject = null;
    }
  };
  
  const zoomIn = () => {
    if (zoomLevel < 2) {
      setZoomLevel(prev => prev + 0.1);
    }
  };
  
  const zoomOut = () => {
    if (zoomLevel > 0.5) {
      setZoomLevel(prev => prev - 0.1);
    }
  };
  
  return (
    <div className="min-h-screen flex flex-col">
      <header className="w-full p-4 border-b border-border/40 flex justify-between items-center">
        <Link to="/dashboard" className="inline-flex items-center text-sm font-medium transition-colors hover:text-primary">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Dashboard
        </Link>
      </header>
      
      <main className="flex-1 p-4 md:p-8 max-w-5xl mx-auto w-full">
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="mb-8"
        >
          <div className="inline-block mb-4">
            <span className="px-3 py-1 rounded-full bg-aidify-coral/10 text-aidify-coral text-sm font-medium">
              Object Detection
            </span>
          </div>
          <h1 className="text-3xl font-bold mb-2">Detect Objects in Images</h1>
          <p className="text-muted-foreground">
            Upload an image or use your camera to identify objects
          </p>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
          className="space-y-6"
        >
          <div className="glass-card p-6 rounded-xl">
            <div className="flex flex-col md:flex-row gap-8">
              <div className="flex-1">
                <div className="bg-muted rounded-xl overflow-hidden relative" style={{ minHeight: "300px" }}>
                  {!imagePreview && !videoRef.current?.srcObject && (
                    <div className="absolute inset-0 flex items-center justify-center flex-col">
                      <Camera className="h-12 w-12 text-muted-foreground/50 mb-4" />
                      <p className="text-muted-foreground">No image selected</p>
                      <p className="text-xs text-muted-foreground/70 mt-1">
                        Upload an image or use your camera
                      </p>
                    </div>
                  )}
                  
                  {imagePreview && (
                    <div className="relative w-full h-full" style={{ minHeight: "300px" }}>
                      <img 
                        src={imagePreview} 
                        alt="Preview" 
                        className="object-contain w-full h-full"
                        style={{ 
                          transform: `scale(${zoomLevel})`,
                          transition: "transform 0.3s ease"
                        }}
                      />
                      
                      {isDetectionComplete && detectedObjects.map((obj, index) => (
                        <div 
                          key={index}
                          className="absolute px-2 py-1 rounded text-white text-xs font-medium"
                          style={{ 
                            backgroundColor: obj.color + "cc",
                            top: `${20 + index * 10}%`,
                            left: `${10 + (index % 3) * 25}%`,
                            border: `1px solid ${obj.color}`,
                            boxShadow: "0 2px 4px rgba(0,0,0,0.2)"
                          }}
                        >
                          {obj.label} ({Math.round(obj.confidence * 100)}%)
                        </div>
                      ))}
                      
                      {isProcessing && (
                        <div className="absolute inset-0 flex items-center justify-center bg-background/50 backdrop-blur-sm">
                          <div className="flex flex-col items-center">
                            <div className="h-10 w-10 rounded-full border-4 border-aidify-coral/30 border-t-aidify-coral animate-spin"></div>
                            <span className="mt-3 text-sm font-medium">Analyzing image...</span>
                          </div>
                        </div>
                      )}
                    </div>
                  )}
                  
                  {!imagePreview && (
                    <video 
                      ref={videoRef} 
                      className="w-full h-full object-cover min-h-[300px]"
                      autoPlay 
                      playsInline
                    ></video>
                  )}
                </div>
                
                <div className="flex justify-between mt-4">
                  <div className="flex items-center space-x-2">
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={zoomOut}
                      disabled={!imagePreview || zoomLevel <= 0.5}
                    >
                      <ZoomOut className="h-4 w-4" />
                    </Button>
                    
                    <div className="text-xs font-medium w-12 text-center">
                      {Math.round(zoomLevel * 100)}%
                    </div>
                    
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={zoomIn}
                      disabled={!imagePreview || zoomLevel >= 2}
                    >
                      <ZoomIn className="h-4 w-4" />
                    </Button>
                  </div>
                  
                  <div className="flex items-center space-x-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => setAudioEnabled(!audioEnabled)}
                    >
                      {audioEnabled ? (
                        <Volume2 className="h-4 w-4" />
                      ) : (
                        <VolumeX className="h-4 w-4" />
                      )}
                    </Button>
                    
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={resetDetection}
                    >
                      <RefreshCw className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </div>
              
              <div className="md:w-64">
                <h2 className="text-lg font-semibold mb-4">Controls</h2>
                
                <div className="space-y-6">
                  <div className="space-y-4">
                    <p className="text-sm font-medium">Upload Image</p>
                    <input
                      ref={fileInputRef}
                      type="file"
                      accept="image/*"
                      className="hidden"
                      onChange={handleImageUpload}
                    />
                    <Button 
                      className="w-full bg-aidify-blue hover:bg-aidify-blue/90"
                      onClick={() => fileInputRef.current?.click()}
                    >
                      <Upload className="mr-2 h-5 w-5" />
                      Upload Image
                    </Button>
                  </div>
                  
                  <div className="border-t border-border/40 pt-4 space-y-4">
                    <p className="text-sm font-medium">Camera</p>
                    <Button 
                      className="w-full bg-aidify-purple hover:bg-aidify-purple/90"
                      onClick={handleCapturePhoto}
                    >
                      <Camera className="mr-2 h-5 w-5" />
                      {videoRef.current?.srcObject ? "Stop Camera" : "Open Camera"}
                    </Button>
                    
                    {videoRef.current?.srcObject && (
                      <Button 
                        className="w-full"
                        onClick={takeSnapshot}
                      >
                        Take Photo
                      </Button>
                    )}
                  </div>
                  
                  {isDetectionComplete && (
                    <div className="border-t border-border/40 pt-4">
                      <p className="text-sm font-medium mb-3">Detected Objects</p>
                      <div className="space-y-2">
                        {detectedObjects.length > 0 ? (
                          detectedObjects.map((obj, index) => (
                            <div 
                              key={index} 
                              className="flex items-center justify-between p-2 rounded-lg"
                              style={{ backgroundColor: obj.color + "10" }}
                            >
                              <span className="font-medium" style={{ color: obj.color }}>
                                {obj.label}
                              </span>
                              <span className="text-xs bg-white px-2 py-1 rounded-full">
                                {Math.round(obj.confidence * 100)}%
                              </span>
                            </div>
                          ))
                        ) : (
                          <p className="text-muted-foreground text-sm">No objects detected</p>
                        )}
                      </div>
                    </div>
                  )}
                  
                  <div className="border-t border-border/40 pt-4">
                    <div className="flex items-center space-x-2">
                      <Switch
                        id="audio-feedback"
                        checked={audioEnabled}
                        onCheckedChange={setAudioEnabled}
                      />
                      <Label htmlFor="audio-feedback">Audio Feedback</Label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          {imagePreview && !isDetectionComplete && !isProcessing && (
            <div className="flex justify-center">
              <Button 
                size="lg"
                className="bg-aidify-coral hover:bg-aidify-coral/90 text-white"
                onClick={processImage}
              >
                <Play className="mr-2 h-5 w-5" />
                Start Detection
              </Button>
            </div>
          )}
        </motion.div>
      </main>
    </div>
  );
};

export default ObjectDetection;
