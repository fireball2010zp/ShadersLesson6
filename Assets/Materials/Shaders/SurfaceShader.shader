Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // свойство цвета материала
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // свойство текстуры материала
        _Glossiness ("Smoothness", Range(0,1)) = 0.5 // свойство отражени€ света
        _Metallic ("Metallic", Range(0,1)) = 0.0 // свойство Ђметаллическогої эффекта поверхности  
        _Emission("Emission", Color) = (1,1,1,1) // свойство внутреннего свечени€

    
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" } // тег показывает, что материал непрозрачный
        LOD 200 // уровень детализации

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows 
        // директива surface включает Ђшейдерї обработки поверхностей
        // Standard - используетс€ стандартна€ модель освещени€
        // fullforwardshadows определ€ет, каким образом будут рассчитыватьс€ тени






        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _Emission;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        
        
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        // принимает параметры: IN Ч переменна€ типа Input, в структуре которой передаютс€ только UV-координаты
        // o Ч переменна€ типа SurfaceOutputStandard, структура которой передаЄт данные дл€ расчЄта освещени€ типа Standard (Glossiness и Metallic, + Emission (эффект внутреннего свечени€) и др.)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
            o.Emission = _Emission.xyz; // (Emission в SurfaceOutputStandard имеет тип float3, поэтому из цвета возьмЄм только xyz-значени€)

        }
        ENDCG
    }
    FallBack "Diffuse"
}
