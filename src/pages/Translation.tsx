
import { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { 
  ArrowLeft, 
  Copy, 
  Save, 
  Mic, 
  ArrowLeftRight, 
  Upload,
  Volume2,
  RefreshCw
} from "lucide-react";
import { toast } from "sonner";
import { motion } from "framer-motion";

const Translation = () => {
  const [sourceText, setSourceText] = useState("");
  const [translatedText, setTranslatedText] = useState("");
  const [sourceLanguage, setSourceLanguage] = useState("en");
  const [targetLanguage, setTargetLanguage] = useState("es");
  const [isTranslating, setIsTranslating] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  
  const handleTranslate = () => {
    if (!sourceText.trim()) {
      toast.error("Please enter text to translate");
      return;
    }
    
    setIsTranslating(true);
    
    // Simulate API call
    setTimeout(() => {
      // Sample translations for demo purposes
      const translations: Record<string, Record<string, string>> = {
        en: {
          es: "Este es un ejemplo de texto traducido al español. En una aplicación real, esto sería reemplazado con una traducción real.",
          fr: "Ceci est un exemple de texte traduit en français. Dans une vraie application, cela serait remplacé par une vraie traduction.",
          de: "Dies ist ein Beispiel für einen ins Deutsche übersetzten Text. In einer echten Anwendung würde dies durch eine echte Übersetzung ersetzt werden.",
          it: "Questo è un esempio di testo tradotto in italiano. In un'applicazione reale, questo verrebbe sostituito con una traduzione reale.",
          ja: "これは日本語に翻訳されたテキストの例です。実際のアプリケーションでは、これは実際の翻訳に置き換えられます。",
          zh: "这是翻译成中文的示例文本。在实际应用中，这将替换为实际翻译。"
        },
        es: {
          en: "This is an example of text translated to English. In a real application, this would be replaced with an actual translation.",
          fr: "Ceci est un exemple de texte traduit en français. Dans une vraie application, cela serait remplacé par une vraie traduction.",
          de: "Dies ist ein Beispiel für einen ins Deutsche übersetzten Text. In einer echten Anwendung würde dies durch eine echte Übersetzung ersetzt werden.",
          it: "Questo è un esempio di testo tradotto in italiano. In un'applicazione reale, questo verrebbe sostituito con una traduzione reale.",
          ja: "これは日本語に翻訳されたテキストの例です。実際のアプリケーションでは、これは実際の翻訳に置き換えられます。",
          zh: "这是翻译成中文的示例文本。在实际应用中，这将替换为实际翻译。"
        }
      };
      
      // Get translation if available, otherwise use placeholder
      const translation = translations[sourceLanguage]?.[targetLanguage] || 
        "This is a placeholder translation. In a real application, this would be replaced with an actual translation.";
      
      setTranslatedText(translation);
      setIsTranslating(false);
      toast.success("Translation complete!");
    }, 1500);
  };
  
  const handleSwapLanguages = () => {
    const tempLang = sourceLanguage;
    setSourceLanguage(targetLanguage);
    setTargetLanguage(tempLang);
    
    // Also swap the text
    setSourceText(translatedText);
    setTranslatedText(sourceText);
  };
  
  const handleCopyText = () => {
    if (!translatedText.trim()) {
      toast.error("No translation to copy");
      return;
    }
    
    navigator.clipboard.writeText(translatedText)
      .then(() => toast.success("Translation copied to clipboard"))
      .catch(() => toast.error("Failed to copy translation"));
  };
  
  const handleSaveText = () => {
    if (!translatedText.trim()) {
      toast.error("No translation to save");
      return;
    }
    
    const blob = new Blob([translatedText], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `translation_${sourceLanguage}_to_${targetLanguage}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    toast.success("Translation saved to file");
  };
  
  const handlePlayTranslation = () => {
    if (!translatedText.trim()) {
      toast.error("No translation to play");
      return;
    }
    
    setIsPlaying(!isPlaying);
    
    if (!isPlaying) {
      toast.info("Playing translation audio...");
    } else {
      toast.info("Audio stopped");
    }
  };
  
  const handleUploadFile = (e: React.ChangeEvent<HTMLInputElement>) => {
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
      setSourceText(content);
      setTranslatedText("");
      toast.success("File uploaded successfully!");
    };
    reader.readAsText(file);
  };
  
  const handleRecordVoice = () => {
    toast.info("Voice recording for translation will be available soon");
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
            <span className="px-3 py-1 rounded-full bg-aidify-teal/10 text-aidify-teal text-sm font-medium">
              Translation
            </span>
          </div>
          <h1 className="text-3xl font-bold mb-2">Language Translation</h1>
          <p className="text-muted-foreground">
            Translate text between multiple languages with high accuracy
          </p>
        </motion.div>
        
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
          className="space-y-6"
        >
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch">
            <div className="glass-card p-6 rounded-xl flex flex-col">
              <div className="flex justify-between items-center mb-4">
                <div className="space-y-1">
                  <Label htmlFor="sourceLanguage">Translate from</Label>
                  <Select value={sourceLanguage} onValueChange={setSourceLanguage}>
                    <SelectTrigger id="sourceLanguage" className="w-[140px]">
                      <SelectValue placeholder="Select language" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="en">English</SelectItem>
                      <SelectItem value="es">Spanish</SelectItem>
                      <SelectItem value="fr">French</SelectItem>
                      <SelectItem value="de">German</SelectItem>
                      <SelectItem value="it">Italian</SelectItem>
                      <SelectItem value="ja">Japanese</SelectItem>
                      <SelectItem value="zh">Chinese</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="flex gap-2">
                  <Button 
                    size="sm" 
                    variant="outline"
                    onClick={handleRecordVoice}
                    title="Record voice"
                  >
                    <Mic className="h-4 w-4" />
                  </Button>
                  <label className="cursor-pointer">
                    <input
                      type="file"
                      accept=".txt"
                      className="hidden"
                      onChange={handleUploadFile}
                    />
                    <Button 
                      size="sm" 
                      variant="outline"
                      type="button"
                      title="Upload text file"
                    >
                      <Upload className="h-4 w-4" />
                    </Button>
                  </label>
                </div>
              </div>
              
              <Textarea
                placeholder="Enter text to translate..."
                className="flex-1 min-h-[200px]"
                value={sourceText}
                onChange={(e) => setSourceText(e.target.value)}
              />
              
              <div className="mt-2 text-xs text-muted-foreground">
                {sourceText.length} characters
              </div>
            </div>
            
            <div className="glass-card p-6 rounded-xl flex flex-col">
              <div className="flex justify-between items-center mb-4">
                <div className="space-y-1">
                  <Label htmlFor="targetLanguage">Translate to</Label>
                  <Select value={targetLanguage} onValueChange={setTargetLanguage}>
                    <SelectTrigger id="targetLanguage" className="w-[140px]">
                      <SelectValue placeholder="Select language" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="en">English</SelectItem>
                      <SelectItem value="es">Spanish</SelectItem>
                      <SelectItem value="fr">French</SelectItem>
                      <SelectItem value="de">German</SelectItem>
                      <SelectItem value="it">Italian</SelectItem>
                      <SelectItem value="ja">Japanese</SelectItem>
                      <SelectItem value="zh">Chinese</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="flex gap-2">
                  <Button 
                    size="sm" 
                    variant="outline"
                    onClick={handleCopyText}
                    disabled={!translatedText.trim()}
                    title="Copy translation"
                  >
                    <Copy className="h-4 w-4" />
                  </Button>
                  <Button 
                    size="sm" 
                    variant="outline"
                    onClick={handleSaveText}
                    disabled={!translatedText.trim()}
                    title="Save translation"
                  >
                    <Save className="h-4 w-4" />
                  </Button>
                  <Button 
                    size="sm" 
                    variant="outline"
                    onClick={handlePlayTranslation}
                    disabled={!translatedText.trim()}
                    title="Listen to translation"
                  >
                    <Volume2 className="h-4 w-4" />
                  </Button>
                </div>
              </div>
              
              <div className="relative flex-1">
                <Textarea
                  placeholder={isTranslating ? "Translating..." : "Translation will appear here..."}
                  className="h-full min-h-[200px]"
                  value={translatedText}
                  onChange={(e) => setTranslatedText(e.target.value)}
                  readOnly
                />
                
                {isTranslating && (
                  <div className="absolute inset-0 flex items-center justify-center bg-background/50 backdrop-blur-sm">
                    <div className="flex flex-col items-center">
                      <div className="h-8 w-8 rounded-full border-4 border-aidify-teal/30 border-t-aidify-teal animate-spin"></div>
                      <span className="mt-3 text-sm font-medium">Translating...</span>
                    </div>
                  </div>
                )}
              </div>
              
              <div className="mt-2 text-xs text-muted-foreground">
                {translatedText.length} characters
              </div>
            </div>
          </div>
          
          <div className="flex justify-center">
            <Button 
              variant="outline" 
              size="icon"
              onClick={handleSwapLanguages}
              className="rounded-full h-10 w-10"
            >
              <ArrowLeftRight className="h-5 w-5" />
            </Button>
          </div>
          
          <div className="flex flex-col sm:flex-row gap-4">
            <Button 
              size="lg"
              className="w-full bg-aidify-teal hover:bg-aidify-teal/90 text-white"
              onClick={handleTranslate}
              disabled={!sourceText.trim() || isTranslating}
            >
              {isTranslating ? "Translating..." : "Translate"}
            </Button>
            
            <Button 
              size="lg" 
              variant="outline" 
              className="w-full"
              onClick={() => {
                setSourceText("");
                setTranslatedText("");
              }}
            >
              <RefreshCw className="mr-2 h-5 w-5" />
              Clear All
            </Button>
          </div>
        </motion.div>
      </main>
    </div>
  );
};

export default Translation;
