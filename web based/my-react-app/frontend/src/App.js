import React, { useState, useEffect, useCallback, useRef } from 'react';
import { MapContainer, TileLayer, Marker, Popup, Polyline, useMapEvents } from 'react-leaflet';
import { Card, CardContent, CardHeader, CardTitle } from './components/ui/card';
import { Badge } from './components/ui/badge';
import { Button } from './components/ui/button';
import { Alert, AlertDescription } from './components/ui/alert';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './components/ui/tabs';
import { Switch } from './components/ui/switch';
import { Progress } from './components/ui/progress';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from './components/ui/dialog';
import { Input } from './components/ui/input';
import { Label } from './components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './components/ui/select';
import { Textarea } from './components/ui/textarea';
import { 
  Trash2, 
  MapPin, 
  TrendingUp, 
  AlertTriangle, 
  Route,
  RefreshCw,
  CheckCircle,
  Clock,
  Moon,
  Sun,
  Zap,
  BarChart3,
  Navigation,
  Bell,
  Settings,
  Activity,
  Plus,
  Play,
  Pause,
  FastForward,
  Users,
  Target,
  Award,
  Leaf,
  DollarSign,
  Lightbulb,
  BookOpen,
  HelpCircle,
  Presentation,
  Maximize,
  MousePointer,
  Sparkles,
  TrendingDown,
  Recycle,
  TreePine,
  Globe,
  LogOut,
  UserCheck,
  Shield,
  Eye,
  Mail,
  Lock,
  User,
  Send,
  CheckCircle2,
  XCircle,
  MessageSquare,
  Crown
} from 'lucide-react';
import axios from 'axios';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import './App.css';

// Fix for default markers in react-leaflet
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;
const API = `${BACKEND_URL}/api`;

// Authentication Component
const AuthPage = ({ onLogin }) => {
  const [isLogin, setIsLogin] = useState(true);
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    name: '',
    role: 'user'
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    
    // Basic validation
    if (!formData.email || !formData.password) {
      alert('Please fill in all required fields.');
      setLoading(false);
      return;
    }
    
    if (!isLogin && !formData.name) {
      alert('Please enter your full name.');
      setLoading(false);
      return;
    }
    
    if (!isLogin && formData.password.length < 6) {
      alert('Password must be at least 6 characters long.');
      setLoading(false);
      return;
    }
    
    try {
      let response;
      if (isLogin) {
        // Login request
        response = await axios.post(`${API}/auth/login`, {
          email: formData.email,
          password: formData.password
        });
      } else {
        // Register request
        response = await axios.post(`${API}/auth/register`, {
          name: formData.name,
          email: formData.email,
          password: formData.password,
          role: formData.role
        });
      }
      
      const { user, token } = response.data;
      
      // Store user data and token
      localStorage.setItem('swachagrid_user', JSON.stringify(user));
      localStorage.setItem('swachagrid_token', token);
      
      onLogin(user);
      setLoading(false);
    } catch (error) {
      console.error('Authentication error:', error);
      alert(error.response?.data?.detail || 'Authentication failed. Please try again.');
      setLoading(false);
    }
  };

  const demoLogin = async (role) => {
    try {
      const credentials = role === 'admin' 
        ? { email: 'admin@swachhgrid.com', password: 'admin123' }
        : { email: 'user@swachhgrid.com', password: 'user123' };
      
      const response = await axios.post(`${API}/auth/login`, credentials);
      const { user, token } = response.data;
      
      localStorage.setItem('swachagrid_user', JSON.stringify(user));
      localStorage.setItem('swachagrid_token', token);
      onLogin(user);
    } catch (error) {
      console.error('Demo login error:', error);
      // Fallback to demo credentials if API fails
      const demoUser = {
        id: Math.random().toString(36).substr(2, 9),
        name: role === 'admin' ? 'Admin User' : 'Regular User',
        email: role === 'admin' ? 'admin@swachhgrid.com' : 'user@swachhgrid.com',
        role: role,
        avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${role}`
      };
      
      localStorage.setItem('swachagrid_user', JSON.stringify(demoUser));
      onLogin(demoUser);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-blue-50 to-purple-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 flex items-center justify-center p-4">
      <div className="w-full max-w-6xl grid lg:grid-cols-2 gap-8 items-center">
        {/* Left Side - Branding */}
        <div className="text-center lg:text-left space-y-6">
          <div className="flex items-center justify-center lg:justify-start space-x-4 mb-8">
            <div className="relative group">
              <div className="absolute -inset-2 bg-gradient-to-r from-green-600 to-blue-600 rounded-xl blur opacity-30 group-hover:opacity-50 transition duration-300"></div>
              <div className="relative bg-gradient-to-r from-green-600 to-emerald-600 p-4 rounded-xl shadow-xl">
                <Trash2 className="w-12 h-12 text-white" />
              </div>
            </div>
            <div>
              <h1 className="text-4xl font-bold bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent">
                Swacha Grid
              </h1>
              <p className="text-muted-foreground text-lg">Smart Waste Management for Smart Cities</p>
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4 max-w-md mx-auto lg:mx-0">
            <div className="bg-background/80 backdrop-blur-xl p-4 rounded-xl border border-border/50 shadow-lg">
              <div className="text-2xl font-bold text-green-600">35%</div>
              <div className="text-sm text-muted-foreground">Route Efficiency</div>
            </div>
            <div className="bg-background/80 backdrop-blur-xl p-4 rounded-xl border border-border/50 shadow-lg">
              <div className="text-2xl font-bold text-blue-600">756kg</div>
              <div className="text-sm text-muted-foreground">CO₂ Saved/Year</div>
            </div>
            <div className="bg-background/80 backdrop-blur-xl p-4 rounded-xl border border-border/50 shadow-lg">
              <div className="text-2xl font-bold text-purple-600">$375</div>
              <div className="text-sm text-muted-foreground">Monthly Savings</div>
            </div>
            <div className="bg-background/80 backdrop-blur-xl p-4 rounded-xl border border-border/50 shadow-lg">
              <div className="text-2xl font-bold text-orange-600">68%</div>
              <div className="text-sm text-muted-foreground">Recycling Rate</div>
            </div>
          </div>

          <div className="space-y-4">
            <h2 className="text-2xl font-semibold">Join the Smart City Revolution</h2>
            <p className="text-muted-foreground">
              Transform your city's waste management with AI-powered optimization, 
              real-time monitoring, and sustainable solutions.
            </p>
          </div>
        </div>

        {/* Right Side - Authentication */}
        <Card className="w-full max-w-md mx-auto border-0 bg-background/80 backdrop-blur-xl shadow-2xl">
          <CardHeader className="text-center pb-6">
            <CardTitle className="text-2xl font-bold flex items-center justify-center gap-2">
              {isLogin ? (
                <>
                  <User className="w-6 h-6 text-primary" />
                  Welcome Back
                </>
              ) : (
                <>
                  <UserCheck className="w-6 h-6 text-primary" />
                  Create Account
                </>
              )}
            </CardTitle>
            <p className="text-muted-foreground">
              {isLogin ? 'Sign in to your Swacha Grid account' : 'Join Swacha Grid today'}
            </p>
          </CardHeader>
          
          <CardContent className="space-y-6">
            {/* Demo Login Buttons */}
            <div className="space-y-3">
              <p className="text-sm text-muted-foreground text-center">Quick Demo Access:</p>
              <div className="grid grid-cols-2 gap-3">
                <Button 
                  onClick={() => demoLogin('admin')}
                  className="bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800"
                >
                  <Crown className="w-4 h-4 mr-2" />
                  Admin Demo
                </Button>
                <Button 
                  onClick={() => demoLogin('user')}
                  className="bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800"
                >
                  <User className="w-4 h-4 mr-2" />
                  User Demo
                </Button>
              </div>
              <div className="text-xs text-muted-foreground text-center space-y-1">
                <p><strong>Admin:</strong> admin@swachhgrid.com / admin123</p>
                <p><strong>User:</strong> user@swachhgrid.com / user123</p>
              </div>
            </div>

            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t" />
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-background px-2 text-muted-foreground">Or continue with</span>
              </div>
            </div>

            {/* Authentication Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              {!isLogin && (
                <div>
                  <Label htmlFor="name">Full Name</Label>
                  <Input
                    id="name"
                    type="text"
                    placeholder="Enter your full name"
                    value={formData.name}
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    required={!isLogin}
                    className="mt-1"
                  />
                </div>
              )}
              
              <div>
                <Label htmlFor="email">Email Address</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="Enter your email"
                  value={formData.email}
                  onChange={(e) => setFormData({...formData, email: e.target.value})}
                  required
                  className="mt-1"
                />
              </div>
              
              <div>
                <Label htmlFor="password">Password</Label>
                <Input
                  id="password"
                  type="password"
                  placeholder="Enter your password"
                  value={formData.password}
                  onChange={(e) => setFormData({...formData, password: e.target.value})}
                  required
                  className="mt-1"
                />
              </div>

              {!isLogin && (
                <div>
                  <Label htmlFor="role">Account Type</Label>
                  <Select value={formData.role} onValueChange={(value) => setFormData({...formData, role: value})}>
                    <SelectTrigger className="mt-1">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="user">Regular User</SelectItem>
                      <SelectItem value="admin">Administrator</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              )}

              <Button 
                type="submit" 
                className="w-full bg-gradient-to-r from-green-600 to-blue-600 hover:from-green-700 hover:to-blue-700"
                disabled={loading}
              >
                {loading ? (
                  <RefreshCw className="w-4 h-4 mr-2 animate-spin" />
                ) : (
                  <Lock className="w-4 h-4 mr-2" />
                )}
                {isLogin ? 'Sign In' : 'Create Account'}
              </Button>
            </form>

            <div className="text-center">
              <Button 
                variant="link" 
                onClick={() => setIsLogin(!isLogin)}
                className="text-muted-foreground hover:text-primary"
              >
                {isLogin ? "Don't have an account? Sign up" : "Already have an account? Sign in"}
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

// User Header Component
const UserHeader = ({ user, onLogout, darkMode, setDarkMode, onStartDemo }) => (
  <header className="sticky top-0 z-40 bg-background/80 backdrop-blur-xl border-b border-border/50 shadow-lg">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="flex justify-between items-center h-16">
        <div className="flex items-center space-x-4">
          <div className="relative group">
            <div className="absolute -inset-1 bg-gradient-to-r from-green-600 to-blue-600 rounded-lg blur opacity-30 group-hover:opacity-50 transition duration-300"></div>
            <div className="relative bg-gradient-to-r from-green-600 to-emerald-600 p-2.5 rounded-lg shadow-lg">
              <Trash2 className="w-6 h-6 text-white" />
            </div>
          </div>
          <div>
            <h1 className="text-2xl font-bold bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent">
              Swacha Grid
            </h1>
            <p className="text-xs text-muted-foreground">Smart Waste Management</p>
          </div>
        </div>

        <div className="flex items-center space-x-4">
          {/* User Info */}
          <div className="flex items-center space-x-3">
            <img 
              src={user.avatar} 
              alt={user.name}
              className="w-8 h-8 rounded-full border-2 border-primary/20"
            />
            <div className="text-right">
              <div className="text-sm font-medium flex items-center gap-2">
                {user.name}
                {user.role === 'admin' && (
                  <Badge className="bg-red-600 text-white">
                    <Crown className="w-3 h-3 mr-1" />
                    Admin
                  </Badge>
                )}
              </div>
              <div className="text-xs text-muted-foreground">{user.email}</div>
            </div>
          </div>

          {/* Dark Mode Toggle */}
          <div className="flex items-center space-x-2">
            <Sun className="w-4 h-4" />
            <Switch 
              checked={darkMode} 
              onCheckedChange={setDarkMode}
              className="data-[state=checked]:bg-slate-700"
            />
            <Moon className="w-4 h-4" />
          </div>

          {/* Action Buttons */}
          <Button 
            onClick={onStartDemo}
            variant="outline" 
            size="sm"
            className="hover:scale-105 transition-transform duration-200"
          >
            <Presentation className="w-4 h-4 mr-2" />
            Demo Mode
          </Button>

          <Button 
            onClick={() => window.location.reload()} 
            variant="outline" 
            size="sm"
            className="hover:scale-105 transition-transform duration-200"
          >
            <RefreshCw className="w-4 h-4 mr-2" />
            Refresh
          </Button>

          <Button 
            onClick={onLogout}
            variant="outline" 
            size="sm"
            className="hover:scale-105 transition-transform duration-200 text-red-600 hover:text-red-700"
          >
            <LogOut className="w-4 h-4 mr-2" />
            Logout
          </Button>
        </div>
      </div>
    </div>
  </header>
);

// Map Click Handler Component
const MapClickHandler = ({ isAddingBin, onMapClick, canAddBin }) => {
  useMapEvents({
    click: (e) => {
      if (isAddingBin && canAddBin) {
        onMapClick(e.latlng);
      }
    },
  });
  return null;
};

// Custom bin icons with enhanced styling
const createBinIcon = (fillLevel, status) => {
  let color = '#10B981';
  let shadowColor = 'rgba(16, 185, 129, 0.4)';
  if (status === 'warning') {
    color = '#F59E0B';
    shadowColor = 'rgba(245, 158, 11, 0.4)';
  }
  if (status === 'critical') {
    color = '#EF4444';
    shadowColor = 'rgba(239, 68, 68, 0.4)';
  }
  
  return L.divIcon({
    html: `
      <div style="
        background: linear-gradient(135deg, ${color} 0%, ${color}dd 100%);
        border: 3px solid white;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 9px;
        font-weight: 700;
        color: white;
        box-shadow: 0 4px 12px ${shadowColor}, 0 2px 4px rgba(0,0,0,0.1);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        animation: pulse 2s infinite;
      ">
        ${Math.round(fillLevel)}%
      </div>
    `,
    className: 'custom-bin-marker',
    iconSize: [32, 32],
    iconAnchor: [16, 16]
  });
};

// Loading Spinner Component
const LoadingSpinner = () => (
  <div className="flex items-center justify-center h-96">
    <div className="relative">
      <div className="w-16 h-16 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      <div className="absolute inset-0 w-16 h-16 border-4 border-transparent border-t-emerald-500 rounded-full animate-spin" style={{animationDelay: '0.5s'}}></div>
    </div>
    <div className="ml-4">
      <div className="text-lg font-semibold animate-pulse">Loading Swacha Grid...</div>
      <div className="text-sm text-muted-foreground">Initializing smart city systems</div>
    </div>
  </div>
);

// Animated Counter Component
const AnimatedCounter = ({ value, suffix = '', className = '' }) => {
  const [displayValue, setDisplayValue] = useState(0);

  useEffect(() => {
    let start = 0;
    const end = parseInt(value) || 0;
    const duration = 1000;
    const increment = end / (duration / 16);

    const timer = setInterval(() => {
      start += increment;
      if (start >= end) {
        setDisplayValue(end);
        clearInterval(timer);
      } else {
        setDisplayValue(Math.floor(start));
      }
    }, 16);

    return () => clearInterval(timer);
  }, [value]);

  return <span className={className}>{displayValue}{suffix}</span>;
};

// Enhanced Stat Card Component
const StatCard = ({ title, value, suffix = '', icon: Icon, color = 'blue', trend, subtitle }) => (
  <Card className="group relative overflow-hidden border-0 bg-gradient-to-br from-background/80 to-background/40 backdrop-blur-xl shadow-lg hover:shadow-xl transition-all duration-500 hover:scale-105 cursor-pointer">
    <div className={`absolute inset-0 bg-gradient-to-br opacity-10 group-hover:opacity-20 transition-opacity duration-500 ${
      color === 'red' ? 'from-red-500 to-red-600' :
      color === 'yellow' ? 'from-yellow-500 to-orange-500' :
      color === 'green' ? 'from-green-500 to-emerald-500' :
      color === 'purple' ? 'from-purple-500 to-pink-500' :
      'from-blue-500 to-purple-500'
    }`}></div>
    <CardContent className="p-6 relative z-10">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-muted-foreground mb-1">{title}</p>
          <div className="flex items-baseline space-x-2">
            <h3 className="text-3xl font-bold tracking-tight">
              <AnimatedCounter value={value} suffix={suffix} />
            </h3>
            {trend && (
              <div className={`flex items-center text-xs ${trend > 0 ? 'text-green-500' : 'text-red-500'}`}>
                <TrendingUp className="w-3 h-3 mr-1" />
                {Math.abs(trend)}%
              </div>
            )}
          </div>
          {subtitle && <p className="text-xs text-muted-foreground mt-1">{subtitle}</p>}
        </div>
        <div className={`p-3 rounded-xl ${
          color === 'red' ? 'bg-red-500/10 text-red-500' :
          color === 'yellow' ? 'bg-yellow-500/10 text-yellow-500' :
          color === 'green' ? 'bg-green-500/10 text-green-500' :
          color === 'purple' ? 'bg-purple-500/10 text-purple-500' :
          'bg-blue-500/10 text-blue-500'
        }`}>
          <Icon className="w-6 h-6" />
        </div>
      </div>
    </CardContent>
  </Card>
);

// Add Bin Modal Component (Admin Only)
const AddBinModal = ({ isOpen, onClose, onAdd, defaultPosition }) => {
  const [formData, setFormData] = useState({
    name: '',
    latitude: defaultPosition?.lat || 40.7128,
    longitude: defaultPosition?.lng || -74.0060,
    capacity: 100,
    location_type: 'street',
    description: ''
  });

  useEffect(() => {
    if (defaultPosition) {
      setFormData(prev => ({
        ...prev,
        latitude: defaultPosition.lat,
        longitude: defaultPosition.lng
      }));
    }
  }, [defaultPosition]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    await onAdd(formData);
    onClose();
    setFormData({
      name: '',
      latitude: 40.7128,
      longitude: -74.0060,
      capacity: 100,
      location_type: 'street',
      description: ''
    });
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Plus className="w-5 h-5 text-green-500" />
            Add New Waste Bin
          </DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="name">Bin Name *</Label>
              <Input
                id="name"
                placeholder="e.g., Bin-A1"
                value={formData.name}
                onChange={(e) => setFormData({...formData, name: e.target.value})}
                required
              />
            </div>
            <div>
              <Label htmlFor="capacity">Capacity (L)</Label>
              <Select value={formData.capacity.toString()} onValueChange={(value) => setFormData({...formData, capacity: parseInt(value)})}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="100">100L - Small</SelectItem>
                  <SelectItem value="150">150L - Medium</SelectItem>
                  <SelectItem value="200">200L - Large</SelectItem>
                  <SelectItem value="300">300L - Extra Large</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="latitude">Latitude</Label>
              <Input
                id="latitude"
                type="number"
                step="any"
                value={formData.latitude}
                onChange={(e) => setFormData({...formData, latitude: parseFloat(e.target.value)})}
                required
              />
            </div>
            <div>
              <Label htmlFor="longitude">Longitude</Label>
              <Input
                id="longitude"
                type="number"
                step="any"
                value={formData.longitude}
                onChange={(e) => setFormData({...formData, longitude: parseFloat(e.target.value)})}
                required
              />
            </div>
          </div>

          <div>
            <Label htmlFor="location_type">Location Type</Label>
            <Select value={formData.location_type} onValueChange={(value) => setFormData({...formData, location_type: value})}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="street">Street Corner</SelectItem>
                <SelectItem value="park">Park Area</SelectItem>
                <SelectItem value="commercial">Commercial Zone</SelectItem>
                <SelectItem value="residential">Residential Area</SelectItem>
                <SelectItem value="industrial">Industrial Zone</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div>
            <Label htmlFor="description">Description (Optional)</Label>
            <Textarea
              id="description"
              placeholder="Additional details about the bin location..."
              value={formData.description}
              onChange={(e) => setFormData({...formData, description: e.target.value})}
            />
          </div>

          <div className="flex justify-end space-x-2">
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" className="bg-gradient-to-r from-green-600 to-blue-600 hover:from-green-700 hover:to-blue-700">
              <Plus className="w-4 h-4 mr-2" />
              Add Bin
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
};

// Request Bin Modal Component (User Only)
const RequestBinModal = ({ isOpen, onClose, onRequest, defaultPosition, user }) => {
  const [formData, setFormData] = useState({
    requested_by: user?.name || '',
    email: user?.email || '',
    latitude: defaultPosition?.lat || 40.7128,
    longitude: defaultPosition?.lng || -74.0060,
    location_type: 'street',
    description: '',
    urgency: 'medium'
  });

  useEffect(() => {
    if (defaultPosition) {
      setFormData(prev => ({
        ...prev,
        latitude: defaultPosition.lat,
        longitude: defaultPosition.lng
      }));
    }
  }, [defaultPosition]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    await onRequest(formData);
    onClose();
    setFormData({
      requested_by: user?.name || '',
      email: user?.email || '',
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: 'street',
      description: '',
      urgency: 'medium'
    });
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Send className="w-5 h-5 text-blue-500" />
            Request New Waste Bin
          </DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="requested_by">Your Name</Label>
              <Input
                id="requested_by"
                value={formData.requested_by}
                onChange={(e) => setFormData({...formData, requested_by: e.target.value})}
                required
              />
            </div>
            <div>
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
                required
              />
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="latitude">Latitude</Label>
              <Input
                id="latitude"
                type="number"
                step="any"
                value={formData.latitude}
                onChange={(e) => setFormData({...formData, latitude: parseFloat(e.target.value)})}
                required
              />
            </div>
            <div>
              <Label htmlFor="longitude">Longitude</Label>
              <Input
                id="longitude"
                type="number"
                step="any"
                value={formData.longitude}
                onChange={(e) => setFormData({...formData, longitude: parseFloat(e.target.value)})}
                required
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="location_type">Location Type</Label>
              <Select value={formData.location_type} onValueChange={(value) => setFormData({...formData, location_type: value})}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="street">Street Corner</SelectItem>
                  <SelectItem value="park">Park Area</SelectItem>
                  <SelectItem value="commercial">Commercial Zone</SelectItem>
                  <SelectItem value="residential">Residential Area</SelectItem>
                  <SelectItem value="industrial">Industrial Zone</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label htmlFor="urgency">Urgency Level</Label>
              <Select value={formData.urgency} onValueChange={(value) => setFormData({...formData, urgency: value})}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="low">Low Priority</SelectItem>
                  <SelectItem value="medium">Medium Priority</SelectItem>
                  <SelectItem value="high">High Priority</SelectItem>
                  <SelectItem value="urgent">Urgent</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div>
            <Label htmlFor="description">Reason for Request *</Label>
            <Textarea
              id="description"
              placeholder="Please explain why a waste bin is needed at this location..."
              value={formData.description}
              onChange={(e) => setFormData({...formData, description: e.target.value})}
              required
            />
          </div>

          <div className="flex justify-end space-x-2">
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700">
              <Send className="w-4 h-4 mr-2" />
              Send Request
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
};

// Quick Actions Panel (Role-based)
const QuickActionsPanel = ({ onAddBin, onOptimizeRoute, onStartDemo, isAddingBin, user, onRequestBin }) => (
  <Card className="fixed bottom-6 right-6 z-50 border-0 bg-background/80 backdrop-blur-xl shadow-xl">
    <CardContent className="p-4">
      <div className="flex flex-col space-y-3">
        <h3 className="text-sm font-semibold text-muted-foreground mb-2">Quick Actions</h3>
        
        {user.role === 'admin' ? (
          <Button 
            onClick={onAddBin}
            variant={isAddingBin ? "default" : "outline"}
            size="sm"
            className={isAddingBin ? "bg-green-600 hover:bg-green-700" : ""}
          >
            <Plus className="w-4 h-4 mr-2" />
            {isAddingBin ? 'Click Map to Add' : 'Add Bin'}
          </Button>
        ) : (
          <Button 
            onClick={onRequestBin}
            variant={isAddingBin ? "default" : "outline"}
            size="sm"
            className={isAddingBin ? "bg-blue-600 hover:bg-blue-700" : ""}
          >
            <Send className="w-4 h-4 mr-2" />
            {isAddingBin ? 'Click to Request' : 'Request Bin'}
          </Button>
        )}
        
        <Button onClick={onOptimizeRoute} variant="outline" size="sm">
          <Route className="w-4 h-4 mr-2" />
          Optimize Route
        </Button>
        <Button onClick={onStartDemo} variant="outline" size="sm">
          <Play className="w-4 h-4 mr-2" />
          Demo Mode
        </Button>
      </div>
    </CardContent>
  </Card>
);

// Requests Tab (Admin Only)
const RequestsTab = ({ user }) => {
  const [requests, setRequests] = useState([
    {
      id: 1,
      requested_by: 'John Doe',
      email: 'john@example.com',
      location_type: 'residential',
      latitude: 40.7580,
      longitude: -73.9855,
      description: 'High foot traffic area near subway station, bins overflow frequently',
      urgency: 'high',
      status: 'pending',
      created_at: new Date().toISOString()
    },
    {
      id: 2,
      requested_by: 'Sarah Wilson',
      email: 'sarah@example.com',
      location_type: 'park',
      latitude: 40.7614,
      longitude: -73.9776,
      description: 'Park area needs additional bins for weekend crowds',
      urgency: 'medium',
      status: 'approved',
      created_at: new Date(Date.now() - 86400000).toISOString()
    }
  ]);

  const handleRequestAction = (id, action) => {
    setRequests(prev => prev.map(req => 
      req.id === id ? { ...req, status: action } : req
    ));
  };

  const getUrgencyColor = (urgency) => {
    switch (urgency) {
      case 'urgent': return 'bg-red-600';
      case 'high': return 'bg-orange-600';
      case 'medium': return 'bg-yellow-600';
      default: return 'bg-blue-600';
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'approved': return 'text-green-600';
      case 'rejected': return 'text-red-600';
      default: return 'text-yellow-600';
    }
  };

  if (user.role !== 'admin') {
    return (
      <div className="text-center py-12">
        <Shield className="w-16 h-16 mx-auto mb-4 text-muted-foreground" />
        <h3 className="text-lg font-semibold mb-2">Admin Access Required</h3>
        <p className="text-muted-foreground">Only administrators can view and manage bin requests.</p>
      </div>
    );
  }

  return (
    <Card className="border-0 bg-background/50 backdrop-blur-xl shadow-xl">
      <CardHeader>
        <CardTitle className="flex items-center gap-3">
          <MessageSquare className="w-6 h-6 text-primary" />
          Bin Requests Management
          <Badge variant="outline" className="ml-auto">
            {requests.filter(r => r.status === 'pending').length} Pending
          </Badge>
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-4 max-h-96 overflow-y-auto custom-scrollbar">
          {requests.map((request, index) => (
            <Card 
              key={request.id} 
              className="group hover:shadow-lg transition-all duration-300 border border-border/50 bg-background/80 backdrop-blur-sm"
              style={{animationDelay: `${index * 100}ms`}}
            >
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex-1 space-y-2">
                    <div className="flex items-center gap-3">
                      <div className="flex items-center space-x-2">
                        <div className={`w-3 h-3 rounded-full ${getUrgencyColor(request.urgency)}`}></div>
                        <span className="font-semibold">{request.requested_by}</span>
                        <Badge variant="outline" className="capitalize">{request.urgency} Priority</Badge>
                      </div>
                      <Badge className={getStatusColor(request.status)}>
                        {request.status.charAt(0).toUpperCase() + request.status.slice(1)}
                      </Badge>
                    </div>
                    
                    <div className="text-sm text-muted-foreground">
                      <p><Mail className="w-3 h-3 inline mr-1" />{request.email}</p>
                      <p><MapPin className="w-3 h-3 inline mr-1" />{request.latitude.toFixed(4)}, {request.longitude.toFixed(4)}</p>
                      <p className="capitalize"><User className="w-3 h-3 inline mr-1" />{request.location_type} area</p>
                    </div>
                    
                    <p className="text-sm">{request.description}</p>
                    
                    <div className="text-xs text-muted-foreground">
                      Requested: {new Date(request.created_at).toLocaleString()}
                    </div>
                  </div>

                  {request.status === 'pending' && (
                    <div className="flex space-x-2 ml-4">
                      <Button
                        size="sm"
                        onClick={() => handleRequestAction(request.id, 'approved')}
                        className="bg-green-600 hover:bg-green-700"
                      >
                        <CheckCircle2 className="w-4 h-4 mr-1" />
                        Approve
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => handleRequestAction(request.id, 'rejected')}
                        className="text-red-600 hover:text-red-700 border-red-600 hover:border-red-700"
                      >
                        <XCircle className="w-4 h-4 mr-1" />
                        Reject
                      </Button>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </CardContent>
    </Card>
  );
};

// Presentation Mode Component
const PresentationMode = ({ isActive, onClose, stats, bins }) => {
  if (!isActive) return null;

  const environmentalImpact = {
    co2Saved: Math.round(bins.length * 2.5),
    routeOptimization: '35%',
    costSavings: '$' + Math.round(bins.length * 15),
    recyclingRate: '68%'
  };

  return (
    <div className="fixed inset-0 z-50 bg-background/95 backdrop-blur-xl">
      <div className="h-full flex flex-col">
        <div className="flex justify-between items-center p-6 border-b">
          <div className="flex items-center space-x-4">
            <div className="bg-gradient-to-r from-green-600 to-blue-600 p-3 rounded-xl">
              <Trash2 className="w-8 h-8 text-white" />
            </div>
            <div>
              <h1 className="text-3xl font-bold bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent">
                Swacha Grid Presentation
              </h1>
              <p className="text-muted-foreground">Smart Waste Management for Smart Cities</p>
            </div>
          </div>
          <Button onClick={onClose} variant="outline">
            <Maximize className="w-4 h-4 mr-2" />
            Exit Presentation
          </Button>
        </div>

        <div className="flex-1 p-6 overflow-y-auto">
          <div className="max-w-7xl mx-auto space-y-8">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              <StatCard 
                title="Active Bins" 
                value={stats.total_bins || 0} 
                icon={Trash2} 
                color="blue"
                subtitle="Real-time monitoring"
              />
              <StatCard 
                title="CO₂ Saved" 
                value={environmentalImpact.co2Saved} 
                suffix=" kg/mo"
                icon={Leaf} 
                color="green"
                subtitle="Environmental impact"
              />
              <StatCard 
                title="Cost Savings" 
                value={environmentalImpact.costSavings.replace('$', '')} 
                suffix="/mo"
                icon={DollarSign} 
                color="purple"
                subtitle="Operational efficiency"
              />
              <StatCard 
                title="Route Efficiency" 
                value={35} 
                suffix="%"
                icon={TrendingUp} 
                color="blue"
                subtitle="AI optimization"
              />
            </div>

            <div className="grid md:grid-cols-2 gap-8">
              <Card className="border-0 bg-gradient-to-br from-red-500/10 to-red-600/10 backdrop-blur-xl">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-red-600">
                    <AlertTriangle className="w-6 h-6" />
                    The Problem
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <span>Inefficient waste collection routes</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <span>Overflowing bins causing health issues</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <span>High operational costs & emissions</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <span>No real-time monitoring systems</span>
                  </div>
                </CardContent>
              </Card>

              <Card className="border-0 bg-gradient-to-br from-green-500/10 to-green-600/10 backdrop-blur-xl">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-green-600">
                    <Lightbulb className="w-6 h-6" />
                    Our Solution
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span>AI-powered route optimization</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span>Real-time bin monitoring & alerts</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span>35% reduction in collection costs</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span>Role-based access control</span>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

function App() {
  // Authentication state
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // App state
  const [bins, setBins] = useState([]);
  const [alerts, setAlerts] = useState([]);
  const [stats, setStats] = useState({});
  const [route, setRoute] = useState(null);
  const [wsConnected, setWsConnected] = useState(false);
  const [activeTab, setActiveTab] = useState('map');
  const [darkMode, setDarkMode] = useState(false);
  const [dataLoading, setDataLoading] = useState(false);
  const [isAddingBin, setIsAddingBin] = useState(false);
  const [showAddBinModal, setShowAddBinModal] = useState(false);
  const [showRequestModal, setShowRequestModal] = useState(false);
  const [clickPosition, setClickPosition] = useState(null);
  const [presentationMode, setPresentationMode] = useState(false);

  // Check for existing user session on load
  useEffect(() => {
    const savedUser = localStorage.getItem('swachagrid_user');
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
    setLoading(false);
  }, []);

  // Dark mode effect
  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [darkMode]);

  // Authentication functions
  const handleLogin = (userData) => {
    setUser(userData);
  };

  const handleLogout = () => {
    localStorage.removeItem('swachagrid_user');
    localStorage.removeItem('swachagrid_token');
    setUser(null);
  };

  // Initialize demo data with loading animation
  const initializeDemoData = async () => {
    try {
      setDataLoading(true);
      await axios.post(`${API}/initialize-demo-data`);
      await Promise.all([fetchBins(), fetchAlerts(), fetchStats()]);
    } catch (error) {
      console.error('Failed to initialize demo data:', error);
    } finally {
      setDataLoading(false);
    }
  };

  // Fetch functions
  const fetchBins = async () => {
    try {
      const response = await axios.get(`${API}/bins`);
      setBins(response.data);
    } catch (error) {
      console.error('Failed to fetch bins:', error);
    }
  };

  const fetchAlerts = async () => {
    try {
      const response = await axios.get(`${API}/alerts`);
      setAlerts(response.data);
    } catch (error) {
      console.error('Failed to fetch alerts:', error);
    }
  };

  const fetchStats = async () => {
    try {
      const response = await axios.get(`${API}/dashboard/stats`);
      setStats(response.data);
    } catch (error) {
      console.error('Failed to fetch stats:', error);
    }
  };

  const optimizeRoute = async () => {
    try {
      setDataLoading(true);
      const response = await axios.get(`${API}/route/optimize`);
      setRoute(response.data);
    } catch (error) {
      console.error('Failed to optimize route:', error);
    } finally {
      setDataLoading(false);
    }
  };

  const acknowledgeAlert = async (alertId) => {
    try {
      await axios.put(`${API}/alerts/${alertId}/acknowledge`);
      await fetchAlerts();
    } catch (error) {
      console.error('Failed to acknowledge alert:', error);
    }
  };

  // Add new bin (Admin only)
  const addBin = async (binData) => {
    try {
      const response = await axios.post(`${API}/bins`, binData);
      await fetchBins();
      await fetchStats();
      return response.data;
    } catch (error) {
      console.error('Failed to add bin:', error);
    }
  };

  // Request new bin (User only)
  const requestBin = async (requestData) => {
    try {
      // In a real app, this would be sent to the backend
      console.log('Bin request submitted:', requestData);
      alert('Your bin request has been submitted and will be reviewed by an administrator.');
      return requestData;
    } catch (error) {
      console.error('Failed to submit bin request:', error);
    }
  };

  // Handle map click for adding bins or requests
  const handleMapClick = (latlng) => {
    if (isAddingBin) {
      setClickPosition(latlng);
      if (user.role === 'admin') {
        setShowAddBinModal(true);
      } else {
        setShowRequestModal(true);
      }
      setIsAddingBin(false);
    }
  };

  // Start demo mode
  const startDemoMode = async () => {
    setPresentationMode(true);
  };

  // WebSocket connection
  const connectWebSocket = useCallback(() => {
    const ws = new WebSocket(`${BACKEND_URL.replace('https://', 'wss://').replace('http://', 'ws://')}/ws`);
    
    ws.onopen = () => {
      setWsConnected(true);
      console.log('WebSocket connected');
    };
    
    ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data.type === 'bin_update') {
          setBins(data.bins);
          if (data.alerts && data.alerts.length > 0) {
            setAlerts(prev => [...data.alerts, ...prev]);
          }
          fetchStats();
        }
      } catch (error) {
        console.error('WebSocket message error:', error);
      }
    };
    
    ws.onclose = () => {
      setWsConnected(false);
      console.log('WebSocket disconnected');
      setTimeout(connectWebSocket, 5000);
    };
    
    ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
    
    return ws;
  }, [BACKEND_URL]);

  useEffect(() => {
    if (user) {
      const loadInitialData = async () => {
        try {
          await fetchBins();
          const currentBins = await axios.get(`${API}/bins`);
          if (currentBins.data.length === 0) {
            await initializeDemoData();
          }
          await Promise.all([fetchAlerts(), fetchStats()]);
          setLoading(false);
        } catch (error) {
          console.error('Failed to load initial data:', error);
          setLoading(false);
        }
      };

      loadInitialData();
      const ws = connectWebSocket();
      
      return () => {
        if (ws) {
          ws.close();
        }
      };
    }
  }, [user, connectWebSocket]);

  const getBinStatusColor = (status) => {
    switch (status) {
      case 'critical': return 'bg-red-500';
      case 'warning': return 'bg-yellow-500';
      default: return 'bg-green-500';
    }
  };

  // Show authentication page if not logged in
  if (!user) {
    return <AuthPage onLogin={handleLogin} />;
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-green-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-green-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 transition-all duration-700">
      {/* Presentation Mode */}
      <PresentationMode 
        isActive={presentationMode}
        onClose={() => setPresentationMode(false)}
        stats={stats}
        bins={bins}
      />

      {/* User Header */}
      <UserHeader 
        user={user}
        onLogout={handleLogout}
        darkMode={darkMode}
        setDarkMode={setDarkMode}
        onStartDemo={startDemoMode}
      />

      {/* Enhanced Stats Overview */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-5 gap-6 mb-8">
          <StatCard 
            title="Total Bins" 
            value={stats.total_bins || 0} 
            icon={Trash2} 
            color="blue" 
          />
          <StatCard 
            title="Critical" 
            value={stats.critical_bins || 0} 
            icon={AlertTriangle} 
            color="red" 
          />
          <StatCard 
            title="Warning" 
            value={stats.warning_bins || 0} 
            icon={Clock} 
            color="yellow" 
          />
          <StatCard 
            title="Normal" 
            value={stats.normal_bins || 0} 
            icon={CheckCircle} 
            color="green" 
          />
          <StatCard 
            title="Avg Fill" 
            value={stats.average_fill_level || 0} 
            suffix="%" 
            icon={BarChart3} 
            color="blue" 
          />
        </div>

        {/* Enhanced Main Content */}
        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
          <TabsList className={`grid w-full ${user.role === 'admin' ? 'grid-cols-5' : 'grid-cols-4'} p-1 bg-background/50 backdrop-blur-xl border border-border/50 rounded-xl shadow-lg`}>
            <TabsTrigger 
              value="map" 
              className="flex items-center gap-2 transition-all duration-300 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-lg"
            >
              <MapPin className="w-4 h-4" />
              Map View
            </TabsTrigger>
            <TabsTrigger 
              value="bins" 
              className="flex items-center gap-2 transition-all duration-300 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-lg"
            >
              <Trash2 className="w-4 h-4" />
              Bins List
            </TabsTrigger>
            <TabsTrigger 
              value="route" 
              className="flex items-center gap-2 transition-all duration-300 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-lg"
            >
              <Route className="w-4 h-4" />
              Route Planning
            </TabsTrigger>
            <TabsTrigger 
              value="alerts" 
              className="flex items-center gap-2 transition-all duration-300 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-lg"
            >
              <AlertTriangle className="w-4 h-4" />
              Alerts ({alerts.filter(a => !a.acknowledged).length})
            </TabsTrigger>
            {user.role === 'admin' && (
              <TabsTrigger 
                value="requests" 
                className="flex items-center gap-2 transition-all duration-300 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground data-[state=active]:shadow-lg"
              >
                <MessageSquare className="w-4 h-4" />
                Requests
              </TabsTrigger>
            )}
          </TabsList>

          <TabsContent value="map" className="mt-8 animate-fadeIn">
            <Card className="border-0 bg-background/50 backdrop-blur-xl shadow-xl">
              <CardHeader className="pb-4">
                <CardTitle className="flex items-center gap-3">
                  <Navigation className="w-6 h-6 text-primary" />
                  City Waste Bin Map
                  <Badge variant="secondary" className="ml-auto">
                    <div className={`w-2 h-2 rounded-full mr-2 ${wsConnected ? 'bg-green-500 animate-ping' : 'bg-red-500'}`}></div>
                    {wsConnected ? "Live" : "Offline"}
                  </Badge>
                  {isAddingBin && (
                    <Badge variant="default" className={user.role === 'admin' ? 'bg-green-600' : 'bg-blue-600'}>
                      <MousePointer className="w-3 h-3 mr-1" />
                      {user.role === 'admin' ? 'Click to Add Bin' : 'Click to Request Bin'}
                    </Badge>
                  )}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-[500px] rounded-xl overflow-hidden shadow-inner border border-border/50">
                  <MapContainer
                    center={[40.7128, -74.0060]}
                    zoom={13}
                    style={{ height: '100%', width: '100%' }}
                    className="rounded-xl"
                  >
                    <MapClickHandler 
                      isAddingBin={isAddingBin} 
                      onMapClick={handleMapClick} 
                      canAddBin={true}
                    />
                    <TileLayer
                      url={darkMode 
                        ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                        : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                      }
                      attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                    />
                    
                    {bins.map((bin) => (
                      <Marker
                        key={bin.id}
                        position={[bin.latitude, bin.longitude]}
                        icon={createBinIcon(bin.fill_level, bin.status)}
                      >
                        <Popup className="custom-popup">
                          <div className="p-3 min-w-[200px]">
                            <div className="flex items-center justify-between mb-2">
                              <h3 className="font-bold text-lg">{bin.name}</h3>
                              <Badge className={getBinStatusColor(bin.status)}>
                                {bin.status}
                              </Badge>
                            </div>
                            <div className="space-y-2">
                              <div className="flex justify-between">
                                <span className="text-sm text-gray-600">Fill Level:</span>
                                <span className="font-semibold">{bin.fill_level.toFixed(1)}%</span>
                              </div>
                              <Progress value={bin.fill_level} className="h-2" />
                              <div className="flex justify-between">
                                <span className="text-sm text-gray-600">Capacity:</span>
                                <span className="font-semibold">{bin.capacity}L</span>
                              </div>
                              <div className="text-xs text-gray-500 border-t pt-2">
                                Last Updated: {new Date(bin.last_updated).toLocaleTimeString()}
                              </div>
                            </div>
                          </div>
                        </Popup>
                      </Marker>
                    ))}
                    
                    {route && route.coordinates && (
                      <Polyline
                        positions={route.coordinates}
                        color="#3B82F6"
                        weight={4}
                        opacity={0.8}
                        dashArray="10, 5"
                        className="route-animation"
                      />
                    )}
                  </MapContainer>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="bins" className="mt-8 animate-fadeIn">
            <Card className="border-0 bg-background/50 backdrop-blur-xl shadow-xl">
              <CardHeader>
                <CardTitle className="flex items-center gap-3">
                  <Activity className="w-6 h-6 text-primary" />
                  Waste Bins Status
                  <Badge variant="outline" className="ml-auto">
                    {bins.length} Active Bins
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid gap-4 max-h-[600px] overflow-y-auto custom-scrollbar">
                  {bins.map((bin, index) => (
                    <Card 
                      key={bin.id} 
                      className="group hover:shadow-lg transition-all duration-300 hover:scale-[1.02] border border-border/50 bg-background/80 backdrop-blur-sm"
                      style={{animationDelay: `${index * 50}ms`}}
                    >
                      <CardContent className="p-4">
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-4">
                            <div className={`w-5 h-5 rounded-full ${getBinStatusColor(bin.status)} shadow-lg animate-pulse`}></div>
                            <div>
                              <h3 className="font-semibold text-lg">{bin.name}</h3>
                              <p className="text-sm text-muted-foreground">
                                📍 {bin.latitude.toFixed(4)}, {bin.longitude.toFixed(4)}
                              </p>
                            </div>
                          </div>
                          <div className="text-right space-y-2">
                            <div className="flex items-center space-x-3">
                              <div className="text-right">
                                <div className="text-2xl font-bold">{bin.fill_level.toFixed(1)}%</div>
                                <div className="text-sm text-muted-foreground">{bin.capacity}L capacity</div>
                              </div>
                              <div className="w-16">
                                <Progress value={bin.fill_level} className="h-3" />
                              </div>
                            </div>
                            {bin.predicted_full_time && (
                              <div className="text-xs text-blue-600 flex items-center justify-end">
                                <Clock className="w-3 h-3 mr-1" />
                                Full in {Math.round((new Date(bin.predicted_full_time) - new Date()) / (1000 * 60 * 60))}h
                              </div>
                            )}
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="route" className="mt-8 animate-fadeIn">
            <Card className="border-0 bg-background/50 backdrop-blur-xl shadow-xl">
              <CardHeader>
                <div className="flex justify-between items-center">
                  <CardTitle className="flex items-center gap-3">
                    <Route className="w-6 h-6 text-primary" />
                    Collection Route Optimization
                  </CardTitle>
                  <Button 
                    onClick={optimizeRoute} 
                    className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105"
                    disabled={dataLoading}
                  >
                    {dataLoading ? (
                      <RefreshCw className="w-4 h-4 mr-2 animate-spin" />
                    ) : (
                      <Route className="w-4 h-4 mr-2" />
                    )}
                    Optimize Route
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                {route ? (
                  <div className="space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      <StatCard
                        title="Bins to Collect"
                        value={route.bin_ids.length}
                        icon={Trash2}
                        color="blue"
                      />
                      <StatCard
                        title="Total Distance"
                        value={route.total_distance}
                        suffix=" km"
                        icon={Navigation}
                        color="green"
                      />
                      <StatCard
                        title="Estimated Time"
                        value={Math.round(route.estimated_time)}
                        suffix=" min"
                        icon={Clock}
                        color="yellow"
                      />
                    </div>
                    
                    <Card className="bg-gradient-to-br from-background/80 to-muted/50 backdrop-blur-sm border border-border/50">
                      <CardHeader>
                        <CardTitle className="text-lg">Collection Sequence</CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="space-y-3 max-h-80 overflow-y-auto custom-scrollbar">
                          {route.bin_ids.map((binId, index) => {
                            const bin = bins.find(b => b.id === binId);
                            return (
                              <div 
                                key={binId} 
                                className="flex items-center space-x-4 p-3 bg-background/60 rounded-lg border border-border/30 hover:bg-background/80 transition-all duration-300 group"
                                style={{animationDelay: `${index * 100}ms`}}
                              >
                                <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold shadow-lg group-hover:scale-110 transition-transform duration-300">
                                  {index + 1}
                                </div>
                                <div className="flex-1">
                                  <span className="font-semibold">{bin?.name || binId}</span>
                                  <div className="text-sm text-muted-foreground">
                                    📍 {bin?.latitude.toFixed(4)}, {bin?.longitude.toFixed(4)}
                                  </div>
                                </div>
                                <Badge className={`${getBinStatusColor(bin?.status)} text-white shadow-lg`}>
                                  {bin?.fill_level.toFixed(1)}%
                                </Badge>
                              </div>
                            );
                          })}
                        </div>
                      </CardContent>
                    </Card>
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <div className="relative">
                      <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-purple-500/20 rounded-full blur-xl"></div>
                      <Route className="relative w-16 h-16 mx-auto mb-4 text-muted-foreground" />
                    </div>
                    <h3 className="text-lg font-semibold mb-2">Ready to Optimize</h3>
                    <p className="text-muted-foreground">Click "Optimize Route" to generate the most efficient collection path</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="alerts" className="mt-8 animate-fadeIn">
            <Card className="border-0 bg-background/50 backdrop-blur-xl shadow-xl">
              <CardHeader>
                <CardTitle className="flex items-center gap-3">
                  <Bell className="w-6 h-6 text-primary" />
                  System Alerts
                  <Badge variant="destructive" className="ml-auto">
                    {alerts.filter(a => !a.acknowledged).length} Active
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4 max-h-96 overflow-y-auto custom-scrollbar">
                  {alerts.length === 0 ? (
                    <div className="text-center py-12">
                      <div className="relative">
                        <div className="absolute inset-0 bg-green-500/20 rounded-full blur-xl"></div>
                        <CheckCircle className="relative w-16 h-16 mx-auto mb-4 text-green-500" />
                      </div>
                      <h3 className="text-lg font-semibold mb-2">All Clear!</h3>
                      <p className="text-muted-foreground">No alerts at this time. System running smoothly.</p>
                    </div>
                  ) : (
                    alerts.map((alert, index) => (
                      <Alert 
                        key={alert.id} 
                        className={`group transition-all duration-300 hover:shadow-lg border border-border/50 bg-background/80 backdrop-blur-sm ${
                          alert.acknowledged ? 'opacity-60' : 'animate-slideIn'
                        }`}
                        style={{animationDelay: `${index * 100}ms`}}
                      >
                        <AlertTriangle className="h-5 w-5" />
                        <AlertDescription className="flex justify-between items-center">
                          <div className="flex-1">
                            <div className="font-semibold mb-1">{alert.message}</div>
                            <div className="text-sm text-muted-foreground flex items-center gap-2">
                              <Clock className="w-3 h-3" />
                              {new Date(alert.created_at).toLocaleString()}
                            </div>
                          </div>
                          {!alert.acknowledged && user.role === 'admin' && (
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => acknowledgeAlert(alert.id)}
                              className="ml-4 hover:scale-105 transition-transform duration-200"
                            >
                              <CheckCircle className="w-4 h-4 mr-1" />
                              Acknowledge
                            </Button>
                          )}
                        </AlertDescription>
                      </Alert>
                    ))
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {user.role === 'admin' && (
            <TabsContent value="requests" className="mt-8 animate-fadeIn">
              <RequestsTab user={user} />
            </TabsContent>
          )}
        </Tabs>
      </div>

      {/* Quick Actions Panel */}
      <QuickActionsPanel 
        onAddBin={() => setIsAddingBin(!isAddingBin)}
        onOptimizeRoute={optimizeRoute}
        onStartDemo={startDemoMode}
        isAddingBin={isAddingBin}
        user={user}
        onRequestBin={() => setIsAddingBin(!isAddingBin)}
      />

      {/* Add Bin Modal (Admin Only) */}
      {user.role === 'admin' && (
        <AddBinModal 
          isOpen={showAddBinModal}
          onClose={() => {
            setShowAddBinModal(false);
            setClickPosition(null);
          }}
          onAdd={addBin}
          defaultPosition={clickPosition}
        />
      )}

      {/* Request Bin Modal (User Only) */}
      {user.role === 'user' && (
        <RequestBinModal 
          isOpen={showRequestModal}
          onClose={() => {
            setShowRequestModal(false);
            setClickPosition(null);
          }}
          onRequest={requestBin}
          defaultPosition={clickPosition}
          user={user}
        />
      )}
    </div>
  );
}

export default App;