Shader "Custom/StencilSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Stencil
        {
            Ref 10 // сравнение с числом 10
            Comp NotEqual // если равны, то не отрисовывать пиксель
        }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}


/*

Параметры для Stencil:

Ref <ref> — оставляет ссылку на некоторое число, с которым в дальнейшем будут
происходить сравнения или операции.

Comp <comparisonOperation> — указывает операцию сравнения. Варианты сравнения: 
Never (никогда)
Less (меньше)
Equal (равно)
LEqual (меньше-равно)
Greater (больше)
NotEqual (не равно)
GEqual (больше-равно)
Always (всегда)

Pass <passOperation> — указывает, что нужно сделать со значением в буфере, если
сравнение прошло успешно. Варианты значения: 
Keep (не менять)
Zero (обнулить)
Replace (заменить)
IncrSat (увеличить на 1 вплоть до 255)
DecrSat (уменьшить на 1 вплоть до 0)
Invert (инвертировать число в двоичном коде)
IncrWrap (увеличить на 1, если больше 255, станет 0)
DecrWrap (уменьшить на 1, если меньше 0, станет 255)

Fail <failOperation> — параметр схож с предыдущим, но указывает, что делать, если
сравнение прошло неуспешно.

*/

