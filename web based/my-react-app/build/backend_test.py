import requests
import sys
import json
from datetime import datetime
import time

class SwachhGridAPITester:
    def __init__(self, base_url="https://smartwaste-4.preview.emergentagent.com"):
        self.base_url = base_url
        self.api_url = f"{base_url}/api"
        self.tests_run = 0
        self.tests_passed = 0
        self.bin_ids = []

    def run_test(self, name, method, endpoint, expected_status, data=None, timeout=30):
        """Run a single API test"""
        url = f"{self.api_url}/{endpoint}" if not endpoint.startswith('http') else endpoint
        headers = {'Content-Type': 'application/json'}

        self.tests_run += 1
        print(f"\n🔍 Testing {name}...")
        print(f"   URL: {url}")
        
        try:
            if method == 'GET':
                response = requests.get(url, headers=headers, timeout=timeout)
            elif method == 'POST':
                response = requests.post(url, json=data, headers=headers, timeout=timeout)
            elif method == 'PUT':
                response = requests.put(url, json=data, headers=headers, timeout=timeout)
            elif method == 'DELETE':
                response = requests.delete(url, headers=headers, timeout=timeout)

            success = response.status_code == expected_status
            if success:
                self.tests_passed += 1
                print(f"✅ Passed - Status: {response.status_code}")
                try:
                    response_data = response.json()
                    if isinstance(response_data, dict) and len(str(response_data)) < 500:
                        print(f"   Response: {response_data}")
                    elif isinstance(response_data, list):
                        print(f"   Response: List with {len(response_data)} items")
                    return True, response_data
                except:
                    return True, response.text
            else:
                print(f"❌ Failed - Expected {expected_status}, got {response.status_code}")
                try:
                    error_data = response.json()
                    print(f"   Error: {error_data}")
                except:
                    print(f"   Error: {response.text}")
                return False, {}

        except requests.exceptions.Timeout:
            print(f"❌ Failed - Request timed out after {timeout} seconds")
            return False, {}
        except Exception as e:
            print(f"❌ Failed - Error: {str(e)}")
            return False, {}

    def test_root_endpoint(self):
        """Test the root API endpoint"""
        return self.run_test("Root API Endpoint", "GET", "", 200)

    def test_initialize_demo_data(self):
        """Test demo data initialization"""
        success, response = self.run_test(
            "Initialize Demo Data", 
            "POST", 
            "initialize-demo-data", 
            200
        )
        if success:
            print(f"   Demo data initialized successfully")
        return success, response

    def test_get_bins(self):
        """Test getting all bins"""
        success, response = self.run_test("Get All Bins", "GET", "bins", 200)
        if success and isinstance(response, list):
            self.bin_ids = [bin.get('id') for bin in response if bin.get('id')]
            print(f"   Found {len(response)} bins")
            if len(response) > 0:
                sample_bin = response[0]
                print(f"   Sample bin: {sample_bin.get('name')} - {sample_bin.get('fill_level')}% full")
        return success, response

    def test_get_single_bin(self):
        """Test getting a single bin by ID"""
        if not self.bin_ids:
            print("⚠️  Skipping single bin test - no bin IDs available")
            return True, {}
        
        bin_id = self.bin_ids[0]
        return self.run_test(f"Get Single Bin ({bin_id[:8]}...)", "GET", f"bins/{bin_id}", 200)

    def test_dashboard_stats(self):
        """Test dashboard statistics"""
        success, response = self.run_test("Dashboard Stats", "GET", "dashboard/stats", 200)
        if success and isinstance(response, dict):
            expected_keys = ['total_bins', 'critical_bins', 'warning_bins', 'normal_bins', 'average_fill_level', 'bins_needing_collection']
            missing_keys = [key for key in expected_keys if key not in response]
            if missing_keys:
                print(f"   ⚠️  Missing keys in response: {missing_keys}")
            else:
                print(f"   Stats: {response['total_bins']} total, {response['critical_bins']} critical, avg fill: {response['average_fill_level']}%")
        return success, response

    def test_route_optimization(self):
        """Test route optimization"""
        success, response = self.run_test("Route Optimization", "GET", "route/optimize", 200)
        if success and isinstance(response, dict):
            expected_keys = ['bin_ids', 'total_distance', 'estimated_time', 'coordinates']
            missing_keys = [key for key in expected_keys if key not in response]
            if missing_keys:
                print(f"   ⚠️  Missing keys in response: {missing_keys}")
            else:
                print(f"   Route: {len(response.get('bin_ids', []))} bins, {response.get('total_distance')} km, {response.get('estimated_time')} min")
        return success, response

    def test_get_alerts(self):
        """Test getting alerts"""
        success, response = self.run_test("Get Alerts", "GET", "alerts", 200)
        if success and isinstance(response, list):
            print(f"   Found {len(response)} alerts")
            if len(response) > 0:
                sample_alert = response[0]
                print(f"   Sample alert: {sample_alert.get('message')} - {sample_alert.get('severity')}")
        return success, response

    def test_create_bin(self):
        """Test creating a new bin"""
        test_bin_data = {
            "name": "Test-Bin-001",
            "latitude": 40.7589,
            "longitude": -73.9851,
            "capacity": 150
        }
        success, response = self.run_test("Create New Bin", "POST", "bins", 200, test_bin_data)
        if success and isinstance(response, dict) and response.get('id'):
            self.bin_ids.append(response['id'])
            print(f"   Created bin with ID: {response['id']}")
        return success, response

    def test_update_bin(self):
        """Test updating a bin"""
        if not self.bin_ids:
            print("⚠️  Skipping bin update test - no bin IDs available")
            return True, {}
        
        bin_id = self.bin_ids[0]
        update_data = {
            "fill_level": 75.5,
            "status": "warning"
        }
        return self.run_test(f"Update Bin ({bin_id[:8]}...)", "PUT", f"bins/{bin_id}", 200, update_data)

    def test_websocket_endpoint(self):
        """Test WebSocket endpoint availability (basic connectivity test)"""
        ws_url = self.base_url.replace('https://', 'wss://').replace('http://', 'ws://') + '/ws'
        print(f"\n🔍 Testing WebSocket Endpoint...")
        print(f"   URL: {ws_url}")
        
        try:
            # We can't easily test WebSocket in this simple test, but we can check if the endpoint exists
            # by trying to connect to the HTTP version and seeing if we get a proper WebSocket upgrade error
            response = requests.get(ws_url.replace('wss://', 'https://').replace('ws://', 'http://'))
            if response.status_code in [400, 426]:  # Bad Request or Upgrade Required
                print("✅ WebSocket endpoint is available (upgrade required as expected)")
                self.tests_passed += 1
            else:
                print(f"⚠️  WebSocket endpoint returned unexpected status: {response.status_code}")
        except Exception as e:
            print(f"⚠️  Could not test WebSocket endpoint: {str(e)}")
        
        self.tests_run += 1
        return True, {}

def main():
    print("🚀 Starting SwachhGrid API Testing...")
    print("=" * 60)
    
    tester = SwachhGridAPITester()
    
    # Test sequence
    test_functions = [
        tester.test_root_endpoint,
        tester.test_initialize_demo_data,
        tester.test_get_bins,
        tester.test_get_single_bin,
        tester.test_dashboard_stats,
        tester.test_route_optimization,
        tester.test_get_alerts,
        tester.test_create_bin,
        tester.test_update_bin,
        tester.test_websocket_endpoint
    ]
    
    failed_tests = []
    
    for test_func in test_functions:
        try:
            success, _ = test_func()
            if not success:
                failed_tests.append(test_func.__name__)
        except Exception as e:
            print(f"❌ Test {test_func.__name__} crashed: {str(e)}")
            failed_tests.append(test_func.__name__)
        
        # Small delay between tests
        time.sleep(0.5)
    
    # Print final results
    print("\n" + "=" * 60)
    print("📊 TEST RESULTS SUMMARY")
    print("=" * 60)
    print(f"Tests Run: {tester.tests_run}")
    print(f"Tests Passed: {tester.tests_passed}")
    print(f"Tests Failed: {tester.tests_run - tester.tests_passed}")
    print(f"Success Rate: {(tester.tests_passed / tester.tests_run * 100):.1f}%")
    
    if failed_tests:
        print(f"\n❌ Failed Tests: {', '.join(failed_tests)}")
    else:
        print("\n✅ All tests passed!")
    
    print("\n🔍 Key Findings:")
    if tester.bin_ids:
        print(f"   - Found {len(tester.bin_ids)} bins in the system")
    else:
        print("   - No bins found or created")
    
    return 0 if tester.tests_passed == tester.tests_run else 1

if __name__ == "__main__":
    sys.exit(main())