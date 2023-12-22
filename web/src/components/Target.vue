<script>
    import Option from './Option.vue';
    export default {
        props: {
            ScreenX: Number,
            ScreenY: Number,
            Closest: Boolean,
            Options: Object,
            DisplayOptions: Boolean,
            TargetID: Number,
        },
        components: {
            Option
        },
        name: 'Target',
    };
</script> 

<template>
    <div class="target" :style="{ top: this.ScreenY + '%', left: this.ScreenX + '%', }">
        <div class="interact">
            <span class="interact-text" v-show="this.Closest">E</span>
        </div>
        <div class="options" v-show="this.DisplayOptions && this.Closest">
            <Option :Options="this.Options" :TargetID="this.TargetID"></Option>
        </div>
    </div>
</template>

<style>

    .target {
        width: auto;
        height: auto;
        position: absolute;
        transform: translate(-50%, 0%);
        transition: scale 150ms ease-in, filter 150ms ease-in;
        display: flex;
    }

    .interact {
        position: absolute;
        border-radius: 50%;
        border-color: #7209b7;
        border-style: solid;
        border-width: 3px;
        background-color: rgba(0, 0, 0, 0.8);
        box-shadow: 3px 3px 18.5px -1px #7209b7;
        width: 22px;
        height: 22px;
        padding: 1px;
    }

    .interact-text {
        color: white;
        text-align: center;
        font-size: 20px;
        font-weight: bold;
        margin-left: 0.5vh;
    }

    .options {
        width: auto;
        height: auto;
        margin-left: 4vh;
    }
</style>