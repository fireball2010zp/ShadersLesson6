Shader "Custom/LambertShader" // шейдер для мобильных платформ
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // свойство цвета материала
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // свойство текстуры материала
        _Emission("Emission", Color) = (1,1,1,1) // свойство внутреннего свечения
        _Height ("Height", Range(0,10)) = 0.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" } // тег показывает, что материал непрозрачный
        LOD 200 // уровень детализации

        CGPROGRAM
        
        #pragma surface surf Lambert noforwardadd noshadow
        // директива surface включает «шейдер» обработки поверхностей
        // Lambert - принимает свет только от 1-го основного источника освещения, не поддерживает Metallic и Glossiness
        // noforwardadd отключает воздействие источников освещения типа Point Light (точечный источник света) и Spot Light (конусный источник света)
        // noshadow - отключает тени, падающие на объект

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        fixed4 _Color;
        float4 _Emission;
        float _Height;

        void surf (Input IN, inout SurfaceOutput o)
        // принимает параметры: IN — переменная типа Input, в структуре которой передаются только UV-координаты
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Emission = _Emission.xyz;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
