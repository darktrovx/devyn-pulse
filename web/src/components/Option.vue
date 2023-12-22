<script>
    import NUI from './NUI.vue';
    export default {
        props: {
            Options: Object,
            TargetID: Number,
        },
        name: 'Option',
        components: {
            NUI
        },
        data() {
            
        },
        methods: {
            SelectedOption: function(index) {
                NUI.methods.NUICallback("SelectedOption", { target: this.TargetID, option: (index + 1) })
            }
        }
    };
</script>

<template>
    <div class="option" v-for="(option, index) in this.Options">
        <span class="option-text" @click="this.SelectedOption(index)">{{ option.label }}</span>
    </div>
</template>

<style>
    .option {
        min-width: 4vw;
        max-width: 15vw;
        height: auto;
    }

    .option-text:hover {
        text-shadow: 2px 2px 13px #ffffff;
        -webkit-text-stroke: 0.2px black;
        color: #7209b7;
    }

    .option-text {
        color: white;
        font-size: 2vh;
        text-align: center;
        font-weight: bold;
        margin-left: 0.5vh;
        width: 100%;
        text-shadow: 2px 2px 13px #7209b7;
    }
</style>