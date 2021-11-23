Pod::Spec.new do |s|
    s.name             = 'YYUIKit'
    s.version          = '1.0.0'
    s.summary      = "A collection of stand-alone production-ready UI libraries focused on design details."
    s.homepage         = 'https://github.com/liuxc123/YYUIKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'liuxc123' => 'lxc_work@126.com' }
    s.source           = { :git => 'https://github.com/liuxc123/YYUIKit.git', :tag => s.version.to_s }
    s.platform     = :ios
    s.requires_arc = true
    s.ios.deployment_target = '10.0'
    
    # AppBar

    s.subspec "AppBar" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]

      # Navigation bar contents
      component.dependency "YYUIKit/NavigationBar"
      component.dependency "YYUIKit/HeaderStackView"
      component.dependency "YYUIKit/private/Application"
      # Flexible header + shadow
      component.dependency "YYUIKit/FlexibleHeader"
      component.dependency "YYUIKit/ShadowLayer"

      component.dependency "YYUIKit/private/UIMetrics"
      component.dependency "YYUIKit/private/Resourse"
    end
    
    # Alert

    s.subspec "Alert" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]

      component.dependency "YYUIKit/Button"
      component.dependency "YYUIKit/Elevation"
      component.dependency "YYUIKit/ShadowLayer"
      component.dependency "YYUIKit/private/KeyboardWatcher"
      component.dependency "YYUIKit/private/Math"
    end
    
    # ActionSheet

    s.subspec "ActionSheet" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]

      component.dependency "YYUIKit/Button"
      component.dependency "YYUIKit/Elevation"
      component.dependency "YYUIKit/ShadowLayer"
      component.dependency "YYUIKit/private/KeyboardWatcher"
      component.dependency "YYUIKit/private/Math"
    end
    
    # Availability
    
    s.subspec "Availability" do |extension|
        extension.ios.deployment_target = '10.0'
        extension.public_header_files = "components/#{extension.base_name}/src/*.h"
        extension.source_files = "components/#{extension.base_name}/src/*.{h,m}"
    end
    
    # BottomSheet

    s.subspec "BottomSheet" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]
      component.framework = "WebKit"

      component.dependency "YYUIKit/Elevation"
      component.dependency "YYUIKit/ShapeLibrary"
      component.dependency "YYUIKit/Shapes"
      component.dependency "YYUIKit/ShadowLayer"
      component.dependency "YYUIKit/private/KeyboardWatcher"
      component.dependency "YYUIKit/private/Math"
    end
    
    # Button

    s.subspec "Button" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]
      component.dependency "YYUIKit/Elevation"
      component.dependency "YYUIKit/ShapeLibrary"
      component.dependency "YYUIKit/Shapes"
      component.dependency "YYUIKit/ShadowLayer"
    end
    
    # Elevation
    
    s.subspec "Elevation" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]
      component.dependency "YYUIKit/Availability"
      component.dependency "YYUIKit/private/Color"
      component.dependency "YYUIKit/private/Math"
    end
    
    # EmptyView
    
    s.subspec "EmptyView" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
      ]
      component.dependency "YYUIKit/Button"
      component.dependency "YYUIKit/private/Color"
      component.dependency "YYUIKit/private/Math"
    end
    
    # FlexibleHeader
    
    s.subspec "FlexibleHeader" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
        ]
        
        component.dependency "YYUIKit/Availability"
        component.dependency "YYUIKit/Elevation"
        component.dependency "YYUIKit/ShadowLayer"
        component.dependency "YYUIKit/private/Application"
        component.dependency "YYUIKit/private/Math"
        component.dependency "YYUIKit/private/UIMetrics"
    end
    
    s.subspec "FlexibleHeader+ShiftBehavior" do |extension|
        extension.ios.deployment_target = '10.0'
        extension.public_header_files = [
        "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
        ]
        extension.source_files = [
        "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"
        ]
    end
    
    s.subspec "FlexibleHeader+ShiftBehaviorEnabledWithStatusBar" do |extension|
        extension.ios.deployment_target = '10.0'
        extension.public_header_files = [
            "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
        ]
        extension.source_files = [
            "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"
        ]
        
        extension.dependency "YYUIKit/FlexibleHeader+ShiftBehavior"
    end
    
    s.subspec "FlexibleHeader+CanAlwaysExpandToMaximumHeight" do |extension|
        extension.ios.deployment_target = '10.0'
        extension.public_header_files = [
            "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
        ]
        extension.source_files = [
            "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"
        ]
        
        extension.dependency "YYUIKit/#{extension.base_name.split('+')[0]}"
    end
    
    # Label
    
    s.subspec "Label" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = "components/#{component.base_name}/src/*.{h,m}"
    end
    
    # HeaderStackView
    
    s.subspec "HeaderStackView" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = "components/#{component.base_name}/src/*.{h,m}"
    end
    
    # NavigationBar

    s.subspec "NavigationBar" do |component|
      component.ios.deployment_target = '10.0'
      component.public_header_files = "components/#{component.base_name}/src/*.h"
      component.source_files = "components/#{component.base_name}/src/*.{h,m}"

      component.dependency "YYUIKit/private/Math"
    end
    
    
    # OverlayWindow
    
    s.subspec "OverlayWindow" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
        ]
        
        component.dependency "YYUIKit/Availability"
        component.dependency "YYUIKit/private/Application"
    end
    
    # ShadowLayer
    
    s.subspec "ShadowLayer" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = "components/#{component.base_name}/src/*.{h,m}"
    end
    
    # ShapeLibrary
    
    s.subspec "ShapeLibrary" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
        
        component.dependency "YYUIKit/Shapes"
        component.dependency "YYUIKit/private/Math"
    end
    
    # Shapes
    
    s.subspec "Shapes" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
        
        component.dependency "YYUIKit/ShadowLayer"
        component.dependency "YYUIKit/private/Color"
        component.dependency "YYUIKit/private/Math"
    end
    
    # Theme
    
    s.subspec "Theme" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
        ]
    end
    
    # Toast
    
    s.subspec "Toast" do |component|
        component.ios.deployment_target = '10.0'
        component.public_header_files = "components/#{component.base_name}/src/*.h"
        component.source_files = [
        "components/#{component.base_name}/src/*.{h,m}",
        "components/#{component.base_name}/src/private/*.{h,m}"
        ]
        
        component.dependency "YYUIKit/private/Resourse"
        component.dependency "YYUIKit/private/KeyboardWatcher"
        component.dependency "YYUIKit/private/UIMetrics"

    end
    
    # private
    
    s.subspec "private" do |private_spec|
        
        private_spec.subspec "Application" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
        end
        
        private_spec.subspec "Color" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
            
            component.dependency "YYUIKit/Availability"
        end
        
        private_spec.subspec "Math" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
        end
        
        private_spec.subspec "KeyboardWatcher" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
            
            component.dependency "YYUIKit/private/Application"
        end
        
        private_spec.subspec "Overlay" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = [
            "components/private/#{component.base_name}/src/*.{h,m}",
            "components/private/#{component.base_name}/src/private/*.{h,m}"
            ]
        end
        
        private_spec.subspec "Resourse" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
            component.resource_bundles = {"Resourse" => ["components/private/#{component.base_name}/src/*.*"]}
        end
        
        private_spec.subspec "UIMetrics" do |component|
            component.ios.deployment_target = '10.0'
            component.public_header_files = "components/private/#{component.base_name}/src/*.h"
            component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
            
            component.dependency "YYUIKit/private/Application"
        end
    end
    
end
