Shader "Custom/LambertShader" // ������ ��� ��������� ��������
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // �������� ����� ���������
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // �������� �������� ���������
        _Emission("Emission", Color) = (1,1,1,1) // �������� ����������� ��������
        _Height ("Height", Range(0,10)) = 0.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" } // ��� ����������, ��� �������� ������������
        LOD 200 // ������� �����������

        CGPROGRAM
        
        #pragma surface surf Lambert noforwardadd noshadow
        // ��������� surface �������� ������� ��������� ������������
        // Lambert - ��������� ���� ������ �� 1-�� ��������� ��������� ���������, �� ������������ Metallic � Glossiness
        // noforwardadd ��������� ����������� ���������� ��������� ���� Point Light (�������� �������� �����) � Spot Light (�������� �������� �����)
        // noshadow - ��������� ����, �������� �� ������

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
        // ��������� ���������: IN � ���������� ���� Input, � ��������� ������� ���������� ������ UV-����������
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
