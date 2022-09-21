Shader "Custom/UnlitTextureMix" // Custom - �������
{
    Properties //�������� �������
    {
    _Tex1 ("Texture1", 2D) = "white" {} // ��-�� ��� �������� ���� 2D
    _Tex2 ("Texture2", 2D) = "white" {} // ��-�� ��� �������� ���� 2D
    _MixValue("MixValue", Range(0,1)) = 0.5 // �������� ���� float ��� ������������ ���������� (Range(0,1) ������ float)
    _Color("Main Color", COLOR) = (1,1,1,1) // �������� ���� COLOR, ������� ����
    _Height("Height", Range(-1,20)) = -1 // ���������� ������ ���� float, ������ �� ���� ������
    }

    SubShader // �������� ��� ��������� �����������
    {
        Tags { "RenderType"="Opaque" } // ��� ����������, ��� �������� ������������
        LOD 100 // ������� ����������� (�����������), ������������ ������ �� �������, �������� LOD ������� ������ ���������

        Pass // �������� ����� ���� �������
        {
            CGPROGRAM // ������ ��������� ��������� � ����������

            #pragma vertex vert // ��������� ������������ �������, ��������� �� ����� vert
            #pragma fragment frag // ��������� ������������ ���������, ��������� �� ����� frag
            #include "UnityCG.cginc" // ���������� ������ �� ���������� UnityCG.cginc (������� �������������� � ����������)

            sampler2D _Tex1; // ��������1
            float4 _Tex1_ST;

            sampler2D _Tex2; // ��������2
            float4 _Tex2_ST;
            
            float _MixValue; // �������� ����������
            float4 _Color; // ����, ������� ����� ������������ �����������
            float _Height; // ���� ������
            
            struct v2f // ��������� ������������� ������ ������� � ������ ��������� (vertex to fragment)
            {
                float2 uv : TEXCOORD0; // UV-���������� �������
                float4 vertex : SV_POSITION; // ���������� �������
            };

            v2f vert(appdata_full v) // ����� ��������� ������, ��������� ���������� ���� appdata_full, ���������� ������ � ���� ��������� ���� v2f
            {
                v2f result; // ���������� result ���� v2f
                
                v.vertex.y += _Height; // (-1 in inspector) - ����� ������� ����� (��� Y) �� ������ _Height
                v.vertex.y += cos(0.45 * v.vertex.x);  // ������� �������� ��������

                result.vertex = UnityObjectToClipPos(v.vertex); // ����� UnityObjectToClipPos ����������� ��������� ���������� ������� � ���������� � ������� ����
                result.uv = TRANSFORM_TEX(v.texcoord, _Tex1); // ������ TRANSFORM_TEX ������� UV-����������
                return result;
            }

            // ����� ��������� �������� (���� �������� ���������� �� ���� ���������)
            fixed4 frag(v2f i) : SV_Target // ����� ��������� �������� � ���� ���������� ���� v2f, � ���������� ���������� ���� fixed4
            {
                fixed4 color; // ����������, �������� ������� ���������� �����
                color = tex2D(_Tex1, i.uv) * _MixValue; // ����� tex2D (UV-����-�� ��-��, �������� ��������) �������� ���� ��������� ����� �� �������� 1
                color += tex2D(_Tex2, i.uv) * (1 - _MixValue); // �������� ���� ��������� ����� �� �������� 2
                color = color * _Color; // ������������� ���������� �����������
                return color; // ��������� ���� ������� ���������
            }

            ENDCG // ����� ��������� ��������� � ����������
        }
    }
}