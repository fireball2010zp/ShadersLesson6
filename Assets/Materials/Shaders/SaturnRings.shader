Shader "Custom/SaturnRings" // for 3D object Plane
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RingsMask("Mask", 2D) = "white" {}
        _RingsColor("Color", Color) = (1,1,1,1)
        _RingsRadius1("InRadius", Range(0.1,0.4)) = 0.4
        _RingsRadius2("OutRadius", Range(0.1,0.5)) = 0.1
    }
        
    SubShader
    {
        Tags { "RenderType" = "Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows keepalpha
        // keepalpha позволяет сохранить альфа-значение функции освещения даже для непрозрачных поверхностей
        #pragma target 3.0

        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_RingsMask;
            float4 color: COLOR;
        };

        sampler2D _MainTex;
        fixed4 _RingsColor;
        float _RingsRadius1;
        float _RingsRadius2;

        void surf(Input IN, inout SurfaceOutputStandard o) 
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _RingsColor;

            fixed radius = 1 - sqrt(pow(IN.uv_RingsMask.x * 2 - 1, 2) + pow(IN.uv_RingsMask.y * 2 - 1, 2));
                       
            clip(radius - _RingsRadius2);
            // объект считается полностью непрозрачным
            o.Alpha = 1;
            o.Albedo = color;

            if (radius > _RingsRadius1) 
            {
                o.Alpha = 0;
            }
        }

        ENDCG
    }

    FallBack "Diffuse"
}