globalvar movementGrid, unitGridLocation, unitQueueForPathfindingList, unitQueueCount, unitQueueMax, selectedUnitsDefaultDirectionToFace;
movementGrid = mp_grid_create(0, 0, floor(room_width / 16), floor(room_width / 16), 16, 16);
unitGridLocation = noone;
unitQueueForPathfindingList = noone;
unitQueueCount = 0;
unitQueueMax = 10;
selectedUnitsDefaultDirectionToFace = -1;

