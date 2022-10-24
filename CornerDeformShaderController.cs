using System;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Playground
{
    [RequireComponent(typeof(Renderer))]
    public class CornerDeformShaderController : MonoBehaviour
    {
        [OnValueChanged("AdjustShaderParams")] [DisableInEditorMode]
        [SerializeField] private float shaderAnimSpeed;
        
        [OnValueChanged("AdjustShaderParams")] [DisableInEditorMode]
        [SerializeField] private float shaderAnimPower;

        [OnValueChanged("AdjustShaderParams")] [DisableInEditorMode]
        [SerializeField] private float distanceSupply;

        private Renderer rend;

        private void Awake()
        {
            rend = GetComponent<Renderer>();
        }

        private void Update()
        {
            rend.material.SetFloat("_distanceToCenterSupport", Mathf.Abs(Mathf.Sin(Time.time)));
        }

        private void AdjustShaderParams()
        {
            rend.material.SetFloat("_animationSpeed", shaderAnimSpeed);
            rend.material.SetFloat("_animationPower", shaderAnimPower);
            rend.material.SetFloat("_distanceToCenterSupport", distanceSupply);
        }
    }
}