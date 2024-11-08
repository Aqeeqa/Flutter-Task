<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET,HEAD,OPTIONS,POST,PUT,DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");

// Database connection details
$host = 'localhost';
$dbname = 'efinder_db';
$username = 'root';
$password = ''; // Default for XAMPP

try {
    // Connect to the database
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['status' => 'Error', 'message' => 'Connection failed: ' . $e->getMessage()]);
    exit;
}

// Initialize response array
$response = [
    "status" => "Loading",
    "data" => [],
    "message" => ""
];

try {
    // Check if search parameters are provided
    $conditions = [];
    $params = [];

    if (isset($_GET['name']) && !empty($_GET['name'])) {
        $conditions[] = "name LIKE :name";
        $params[':name'] = "%" . $_GET['name'] . "%";
    }

    if (isset($_GET['id']) && !empty($_GET['id'])) {
        $conditions[] = "id = :id";
        $params[':id'] = $_GET['id'];
    }

    // Build SQL query
    $sql = "SELECT id, name FROM humans";
    if (!empty($conditions)) {
        $sql .= " WHERE " . implode(" AND ", $conditions);
    }

    // Prepare and execute statement
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);

    // Fetch data
    $humans = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Set response data
    if ($humans) {
        $response["status"] = "Loaded";
        $response["data"] = $humans;
    } else {
        $response["status"] = "Empty";
        $response["message"] = "No humans found.";
    }
} catch (PDOException $e) {
    $response["status"] = "Error";
    $response["message"] = "Database error: " . $e->getMessage();
}

// Output response as JSON
echo json_encode($response);
