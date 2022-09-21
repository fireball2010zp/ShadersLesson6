Shader "Custom/AtmosphereTexture"
{
    Properties
    {
    _TexPlanet("Texture", 2D) = "white" {}
    _ColorPlanet("ColorPlanet", COLOR) = (1,1,1,1)
    _ColorAtmosphere("ColorAtmosphere", COLOR) = (1,1,1,1)
    _AtmosphereHeight("AtmosphereHeight", float) = 0.5
    }

    SubShader 
    {
        Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
        LOD 100 
        Blend SrcAlpha OneMinusSrcAlpha

        Pass 
        {
            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc" 

            sampler2D _TexPlanet;
            float4 _TexPlanet_ST;
            
            float4 _ColorPlanet;
            
            struct v2f 
            {
                float2 uv : TEXCOORD0; 
                float4 vertex : SV_POSITION; 
            };

            v2f vert(appdata_full v)
            {
                v2f result;
                result.vertex = UnityObjectToClipPos(v.vertex); 
                result.uv = TRANSFORM_TEX(v.texcoord, _TexPlanet); 
                return result;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 colorPlanet;
                colorPlanet = tex2D(_TexPlanet, i.uv);
                colorPlanet = colorPlanet * _ColorPlanet;
                return colorPlanet;
            }

            ENDCG
        }

        Pass 
        {
            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc" 

            sampler2D _TexAtmosphere;
            float4 _TexAtmosphere_ST;
            
            float4 _ColorAtmosphere; 
            float _AtmosphereHeight;
            
            struct v2f 
            {
                float2 uv : TEXCOORD0; 
                float4 vertex : SV_POSITION; 
            };

            v2f vert(appdata_full v)
            {
                v2f result;
                v.vertex.xyz += v.normal * _AtmosphereHeight;
                result.vertex = UnityObjectToClipPos(v.vertex); 
                result.uv = TRANSFORM_TEX(v.texcoord, _TexAtmosphere); 
                return result;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 colorAtmosphere;
                colorAtmosphere = tex2D(_TexAtmosphere, i.uv);
                colorAtmosphere = colorAtmosphere * _ColorAtmosphere;
                return colorAtmosphere;
            }

            ENDCG
        }

    }
}
