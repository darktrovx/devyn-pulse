<script>

  import NUI from './components/NUI.vue';
  import Target from './components/Target.vue';

  export default {
    components: {
      NUI,
      Target
    },
    data() {
        return {
          Display: false,
          DisplayID: 0,
          Targets: [],
        }
    },
    methods: {
      Open: function() {
        this.Display = true;
      },
      Close: function() {
        this.Targets = [];
        this.Display = false;
        this.DisplayID = 0;
        NUI.methods.NUICallback("close")
      },
      Update: function(targets) {
        if (targets.length == 0) { return }
        this.Targets = targets;
      },
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch(event.data.type) {
                case "open":
                    this.Open()
                    break;
                case "close":
                    this.Close()
                    break;
                case "update":
                  var i = this.Targets.findIndex(x => x.id == event.data.target.id);  
                  if (i == -1) {
                      this.Targets.push(event.data.target);
                  } else {
                      this.Targets[i] = event.data.target;
                  }
                  break;
                case "openOptions":
                  var i = this.Targets.findIndex(x => x.id == event.data.id);
                  
                  if (i != -1) {
                    this.Targets[this.DisplayID].displayOptions = false 
                    this.Targets[i].displayOptions = true
                    this.DisplayID = i
                  }
                  break;
                default:
                    this.Close()
                    break;
            }
        });

        this.listener = window.addEventListener("keyup", (event) => {
            if (event.key == 'Escape') {
                NUI.methods.NUICallback("close")
            }
        });
    },
}
</script>

<template>

  <div v-show="this.Display">
    <Target v-for="target in this.Targets" 
      :ScreenY="target.y" 
      :ScreenX="target.x" 
      :Options="target.options" 
      :Closest="target.closest"
      :DisplayOptions="target.displayOptions"
      :TargetID="target.id"
    />
  </div>

</template>

<style>
</style>