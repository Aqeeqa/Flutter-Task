<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET,HEAD,OPTIONS,POST,PUT,DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");

$host = 'localhost';
$db = 'efinder_db'; // replace with your actual database name
$user = 'root'; // replace with your actual database user
$pass = ''; // replace with your actual database password
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    echo json_encode([
        "status" => "Error",
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}

$response = [
    "status" => "Loading",
    "data" => [],
    "message" => ""
];

if (isset($_GET['id'])) {
    $id = $_GET['id'];

    try {
        $sql = "SELECT id, name, details FROM humans WHERE id = :id";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();

        $human = $stmt->fetch();

        if ($human) {
            $response["status"] = "Loaded";
            $response["data"] = $human;
        } else {
            $response["status"] = "Empty";
            $response["message"] = "Human not found.";
        }
    } catch (PDOException $e) {
        $response["status"] = "Error";
        $response["message"] = "Database error: " . $e->getMessage();
    }
} else {
    $response["status"] = "Error";
    $response["message"] = "ID parameter is missing.";
}

echo json_encode($response);
?>
